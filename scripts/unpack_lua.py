#!/usr/bin/env python3
"""从 CN 官方 CDN 一手解包出可读的 Lua 源码树。

两条链路（细节见 docs/DECRYPT.md）：

A. `scripts32` —— 39 MB，整体加密的 UnityFS
       uabdec 整包解密 → UnityPy 取 TextAsset
       container 形如 `assets/luabuilds/android/normal/sharecfg/xxx.lua.bytes`
       → 每个 asset 的字节码先 bcdec、再 ljd 反编译
       → `lua/<相对路径>`（去掉 `.bytes`）

B. `sharecfgdata/<表名>` —— 35 个独立 bundle，自定义容器
       文件 = 连续的 `[uleb128 长度][LuaJIT 字节码]` 片段
       每段补上 `\\x1bLJ\\x02\\x02` 头就是一个完整的 BC dump
       → 逐段 bcdec + ljd，再把文本拼起来
       → `lua/sharecfgdata/<表名>.lua`

增量策略（`data/manifest.json`）：
    - bundle 的 md5 没变 → 整段跳过（不下载、不解密）
    - 单个脚本的字节码 md5 没变，且文件还在 → 沿用仓库里现成的 `.lua`
    - 反过来，远端已经消失的文件会被删掉，保证 `lua/` 与线上完全一致

用法：
    python scripts/unpack_lua.py --server CN --jobs 4
    python scripts/unpack_lua.py --server CN --force --skip gamecfg,view
"""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _common import (append_summary, die, log, read_json, set_output, warn,
                     write_json, write_text)  # noqa: E402
from cdn import (SERVERS, azhash_of, fetch_bundle, fetch_hash_list,
                 get_version)  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
TOOLS = ROOT / "tools"

LJ_HEADER = b"\x1bLJ\x02\x02"
TEXTASSET_PREFIX = "assets/luabuilds/android/normal/"
SCRIPT_SUFFIX = ".lua.bytes"
SHARECFGDATA_PREFIX = "sharecfgdata/"


# --------------------------------------------------------------------- 工具链

def _tool(name: str) -> Path:
    for cand in (TOOLS / name, TOOLS / (name + ".exe")):
        if cand.exists():
            return cand
    die(f"缺少 {name}，请在 tools/ 下放好（来源见 tools/README.md）")


def bcdec(data: bytes, timeout: int = 300) -> bytes:
    """bcdec：魔改 LuaJIT 字节码 → 标准 LuaJIT 字节码。

    走 stdin/stdout，不落盘。输入输出**都**是完整的 BC dump，头尾不要动：
        输入：`\\x1bLJ\\x02\\x02` + uleb128(proto 长度) + proto + `\\x00`
        输出：同长度、同为完整 dump
    早先这里按 `out[5:-1]` 剥掉头尾再拼字节码是错的 —— ljd 拿到没有头的
    字节流只会报 `'NoneType' object has no attribute 'constants'`。
    """
    proc = subprocess.run(
        [str(_tool("bcdec"))], input=data, stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, timeout=timeout,
    )
    if proc.returncode != 0:
        raise RuntimeError(f"bcdec 失败({proc.returncode}): "
                           f"{proc.stderr.decode('u8', 'replace')[:200]}")
    out = proc.stdout
    if not out.startswith(LJ_HEADER):
        warn(f"bcdec 输出不是以 LJ 头开头（前 8 字节 {out[:8].hex(' ')}），照原样交给 ljd")
    return out


def decompile(bytecode: bytes) -> str:
    """ljd：标准 LuaJIT 字节码 → lua 源码。"""
    try:
        import ljd.tools  # noqa: PLC0415
    except ImportError:
        die("缺少 ljd，请 pip install "
            "https://github.com/AzurLaneTools/ljd/releases/download/wheel/"
            "ljd-0.1.7-py3-none-any.whl")
        raise
    return ljd.tools.process_bytes(bytecode)


def uabdec(src: Path, dst: Path) -> None:
    """uabdec：整体加密的 UnityFS → 明文 UnityFS。"""
    dst.parent.mkdir(parents=True, exist_ok=True)
    log(f"uabdec 解密 {src.name}（{src.stat().st_size / 1e6:.1f} MB）")
    proc = subprocess.run([str(_tool("uabdec")), str(src), str(dst)],
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                          timeout=1800)
    if proc.returncode != 0 or not dst.exists():
        raise RuntimeError(f"uabdec 失败({proc.returncode}): "
                           f"{proc.stderr.decode('u8', 'replace')[:300]}")


def read_uleb128(data: bytes, idx: int = 0) -> tuple[int, int]:
    result = shift = 0
    for _ in range(5):
        b = data[idx]
        result += (b & 0x7F) << shift
        idx += 1
        shift += 7
        if b < 0x80:
            return idx, result
    raise ValueError(f"uleb128 过长 @ {idx}")


def iter_segments(data: bytes):
    """按容器格式切分，产出可喂给 bcdec 的完整 BC dump。"""
    idx = 0
    size = len(data)
    while idx < size:
        start = idx
        new_idx, num = read_uleb128(data, idx)
        idx = new_idx + num
        if idx > size:
            # 尾部残段：不报错，交给上层判空
            break
        yield LJ_HEADER + data[start:idx] + b"\x00"


# ------------------------------------------------------------------ scripts32

def collect_scripts(dec_bundle: Path, skip: tuple[str, ...]) -> dict[str, bytes]:
    """明文 scripts32 → {相对路径(.lua): 字节码}"""
    import UnityPy  # noqa: PLC0415

    log("UnityPy 加载 scripts32（四万多个 TextAsset，需要一两分钟）")
    env = UnityPy.load(str(dec_bundle))
    found: dict[str, bytes] = {}
    odd: list[str] = []
    for reader in env.objects:
        if reader.type.name != "TextAsset":
            continue
        path = str(reader.container).replace("\\", "/")
        if not path.endswith(SCRIPT_SUFFIX):
            continue
        if path.startswith(TEXTASSET_PREFIX):
            rel = path[len(TEXTASSET_PREFIX):]
        else:
            rel = path.split("assets/", 1)[-1]
            if len(odd) < 3:
                odd.append(path)
        rel = rel[:-len(".bytes")]            # xxx.lua.bytes -> xxx.lua
        if skip and rel.startswith(skip):
            continue
        # UnityPy 1.10+ 把 TextAsset 的脚本体改叫 m_Script，且已经解成 str
        # （utf-8 + surrogateescape）；这里 encode 回去才是原始字节。
        # 不用这个逆变换，二进制字节码会被 str 化搞坏。
        found[rel] = reader.read().m_Script.encode("utf-8", "surrogateescape")
    if odd:
        warn(f"{len(odd)} 个 TextAsset 不在 {TEXTASSET_PREFIX} 下，示例：{odd}")
    log(f"scripts32 里共 {len(found)} 个 .lua")
    return found


def decompile_into(targets: list[tuple[str, bytes]], lua_dir: Path, jobs: int) -> list[tuple[str, str]]:
    """并发跑 bcdec+ljd，写盘。返回失败列表 [(rel, 错误)]。"""
    failures: list[tuple[str, str]] = []
    done = 0
    started = time.time()

    def one(item: tuple[str, bytes]):
        rel, raw = item
        text = decompile(bcdec(raw))
        write_text(lua_dir / rel, text)
        return rel

    with ThreadPoolExecutor(max_workers=max(1, jobs)) as pool:
        futures = {pool.submit(one, item): item[0] for item in targets}
        for future in futures:
            rel = futures[future]
            try:
                future.result()
            except Exception as exc:  # noqa: BLE001
                failures.append((rel, f"{type(exc).__name__}: {exc}"))
                continue
            done += 1
            if done % 2000 == 0:
                rate = done / max(1e-6, time.time() - started)
                log(f"  反编译 {done}/{len(targets)}（{rate:.0f} 个/秒）")
    return failures


# --------------------------------------------------------------- sharecfgdata

def unpack_sharecfgdata(bundle: Path) -> str:
    """一个 sharecfgdata bundle → lua 源码。

    每段 bcdec 之后都是**独立完整**的 BC dump，所以逐段反编译、再拼文本。
    不要先拼字节码再一次性反编译（实测三种拼法全部失败）。
    """
    raw = bundle.read_bytes()
    texts = [decompile(bcdec(seg)) for seg in iter_segments(raw)]
    if not texts:
        raise ValueError(f"{bundle.name}: 切分出 0 个片段")
    return "\n".join(texts)


# ---------------------------------------------------------------------- 清理

def prune(lua_dir: Path, keep: set[str], protected: tuple[str, ...]) -> int:
    """删掉远端已经没有的 .lua，保证 lua/ 是线上内容的精确镜像。"""
    removed = 0
    dirs: set[Path] = set()
    for path in lua_dir.rglob("*.lua"):
        rel = path.relative_to(lua_dir).as_posix()
        if rel in keep:
            continue
        if protected and rel.startswith(protected):
            continue          # --skip 掉的目录不归本轮管
        path.unlink()
        dirs.add(path.parent)
        removed += 1
    for directory in sorted(dirs, key=lambda p: len(p.parts), reverse=True):
        try:
            directory.rmdir()
        except OSError:
            pass
    return removed


# ------------------------------------------------------------------------ main

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--server", default="CN", choices=list(SERVERS))
    ap.add_argument("--lua-dir", default="lua", help="源码输出目录")
    ap.add_argument("--work", default=".work", help="临时目录（放解密后的 bundle）")
    ap.add_argument("--manifest", default="data/manifest.json")
    ap.add_argument("--state", default="data/version.json")
    ap.add_argument("--versions", default="versions", help="写 <服>.txt 的目录")
    ap.add_argument("--jobs", type=int, default=4, help="bcdec 并发数")
    ap.add_argument("--skip", default="", help="跳过这些顶层目录（逗号分隔）")
    ap.add_argument("--max-failures", type=int, default=50)
    ap.add_argument("--force", action="store_true", help="忽略 md5 缓存全量重解")
    args = ap.parse_args()

    root = Path.cwd()
    lua_dir = (root / args.lua_dir).resolve()
    work = (root / args.work).resolve()
    manifest_path = root / args.manifest
    state_path = root / args.state
    lua_dir.mkdir(parents=True, exist_ok=True)
    work.mkdir(parents=True, exist_ok=True)

    skip = tuple(s.strip().strip("/") + "/" for s in args.skip.split(",") if s.strip())
    if skip:
        log(f"跳过目录：{', '.join(skip)}")

    started = time.time()
    manifest = read_json(manifest_path)
    old_bundles: dict = manifest.get("bundles") or {}
    old_scripts: dict = manifest.get("scripts") or {}

    # ---- 1. 版本 + 清单
    az_raw, version, stamp = azhash_of(get_version(args.server))
    _host, _port, cdn = SERVERS[args.server]
    listing = fetch_hash_list(cdn, az_raw)
    log(f"az 清单 {len(listing)} 条，版本 {version}")
    if "scripts32" not in listing:
        die("清单里没有 scripts32")

    bundles: dict[str, str] = {}
    scripts: dict[str, str] = {}
    failures: list[tuple[str, str]] = []

    # ---- 2. scripts32 → lua/*
    sc32_md5 = listing["scripts32"]["md5"]
    bundles["scripts32"] = sc32_md5
    dec = work / f"scripts32-{sc32_md5[:12]}.dec"
    if not args.force and old_bundles.get("scripts32") == sc32_md5 and dec.exists():
        log("scripts32 未变化，跳过解密")
    else:
        bundle = fetch_bundle(cdn, listing, "scripts32", work / "scripts32",
                              reuse=old_bundles.get("scripts32") == sc32_md5)
        uabdec(bundle, dec)
        bundle.unlink(missing_ok=True)
        for stale in work.glob("scripts32-*.dec"):
            if stale != dec:
                stale.unlink()          # 上一版解出来的，别留着占地方

    if not args.force and old_bundles.get("scripts32") == sc32_md5 and dec.exists():
        # 清单没变：脚本集合按 manifest 复原，逐个核对文件是否还在
        scripts = dict(old_scripts)
        missing = [rel for rel in scripts if not (lua_dir / rel).exists()]
        if missing:
            warn(f"{len(missing)} 个脚本文件缺失，需要重解 scripts32")
            assets = collect_scripts(dec, skip)
            targets = [(rel, raw) for rel, raw in assets.items()
                       if not (lua_dir / rel).exists()]
            failures += decompile_into(targets, lua_dir, args.jobs)
            scripts = {rel: hashlib.md5(raw).hexdigest() for rel, raw in assets.items()}
    else:
        assets = collect_scripts(dec, skip)
        log("计算字节码 md5")
        digests = {rel: hashlib.md5(raw).hexdigest() for rel, raw in assets.items()}
        targets = [
            (rel, raw) for rel, raw in assets.items()
            if args.force or old_scripts.get(rel) != digests[rel]
            or not (lua_dir / rel).exists()
        ]
        log(f"需要反编译 {len(targets)}/{len(assets)} 个脚本")
        failures += decompile_into(targets, lua_dir, args.jobs)
        scripts = digests

    # ---- 3. sharecfgdata/* → lua/sharecfgdata/*.lua
    scd_items = [(p, meta) for p, meta in sorted(listing.items())
                 if p.startswith(SHARECFGDATA_PREFIX)]
    log(f"sharecfgdata 共 {len(scd_items)} 个 bundle")
    for path, meta in scd_items:
        name = path.split("/", 1)[1]
        bundles[path] = meta["md5"]
        dest = lua_dir / "sharecfgdata" / f"{name}.lua"
        protected = path.startswith(skip) if skip else False
        if protected:
            continue
        if not args.force and old_bundles.get(path) == meta["md5"] and dest.exists():
            continue
        bundle = work / f"scd-{name}"
        try:
            fetch_bundle(cdn, listing, path, bundle,
                         reuse=old_bundles.get(path) == meta["md5"])
            text = unpack_sharecfgdata(bundle)
            write_text(dest, text)
            log(f"  {name}: {len(text) / 1e6:.1f} MB")
        except Exception as exc:  # noqa: BLE001
            failures.append((f"sharecfgdata/{name}", f"{type(exc).__name__}: {exc}"))
            warn(f"sharecfgdata/{name} 失败：{exc}")
        finally:
            bundle.unlink(missing_ok=True)

    # ---- 4. 清理 + 落盘
    keep = set(scripts) | {f"sharecfgdata/{p.split('/', 1)[1]}.lua" for p, _ in scd_items}
    removed = prune(lua_dir, keep, skip)
    if removed:
        log(f"清理远端已删除的脚本 {removed} 个")

    # --skip 的目录保留旧记录，避免下一轮误以为它们变了
    for rel, md5 in old_scripts.items():
        if skip and rel.startswith(skip) and rel not in scripts:
            scripts[rel] = md5
    for path, md5 in old_bundles.items():
        if skip and path.startswith(skip) and path not in bundles:
            bundles[path] = md5

    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    status = "ok" if not failures else "partial"
    write_json(manifest_path, {
        "version": version,
        "az": az_raw,
        "updated_at": now,
        "bundles": bundles,
        "scripts": scripts,
    })
    state = read_json(state_path)
    state[args.server] = {
        "az": az_raw, "version": version, "stamp": stamp,
        "status": status, "checked_at": now, "generated_at": now,
        "scripts": len(scripts), "bundles": len(bundles),
    }
    write_json(state_path, state)
    write_text(root / args.versions / f"{args.server}.txt", version)

    elapsed = time.time() - started
    log(f"完成：{len(scripts)} 个脚本 / {len(scd_items)} 张 sharecfgdata / "
        f"{len(failures)} 项失败 / {elapsed:.0f}s")

    set_output(status=status, scripts=len(scripts), bundles=len(bundles),
               failures=len(failures), seconds=f"{elapsed:.0f}", version=version)
    append_summary(
        f"### Lua 解包（{args.server}）\n"
        f"- 版本：`{version}`（`{az_raw.strip('$')}`）\n"
        f"- 脚本：`{len(scripts)}` 个；sharecfgdata：`{len(scd_items)}` 个\n"
        f"- 清理旧文件：`{removed}`；耗时：`{elapsed:.0f}s`\n"
        + (f"- ⚠️ 失败 `{len(failures)}` 项：" +
           "、".join(f"`{rel}`" for rel, _ in failures[:8]) + "\n" if failures else "")
    )
    if failures:
        for rel, err in failures[:20]:
            warn(f"{rel} 失败：{err}")
        if len(failures) > args.max_failures:
            die(f"失败 {len(failures)} 项，超过阈值 {args.max_failures}，本轮不提交")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
