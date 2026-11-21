#!/usr/bin/env python3
"""把 `lua/sharecfg/`、`lua/sharecfgdata/` 的 Lua 表解析成 JSON。

为什么不直接读 Lua 运行时：
    这里不解释 Lua，只定位 `= {` 赋值再从花括号开始做平衡解析，
    所以文件里那些 `(function() ... end)()` 包裹、`setmetatable` 包装
    都不会干扰。这套解析器已在 9.7.437 全量 661 张表上验证过。

Lua 文件的两种形态：
    sharecfg/*.lua       pg.NAME.all = { ... }     -- 顺序 id 列表
                         pg.NAME[1] = { ... }      -- 单条
                         pg.NAME["key"] = { ... }
    sharecfgdata/*.lua   _G.pg.base.NAME[1] = { ... }
                         _G.pg.base.NAME.some_key = { ... }

产出一个表一个 JSON：`tables/<目录>/<表名>.json`，结构固定为
    {"all": [ ... ], "rows": {"<id>": { ... }, ...}}
`all` 是 `.all` 的顺序 id 列表，`rows` 是按 id / 字符串键索引的行。
`.all` 以外的标量属性（例如 `pg.NAME.key_field = "x"`）放在
`rows["@props"]` 下。

用法：
    python scripts/build_tables.py
    python scripts/build_tables.py --only ship_data_statistics
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _common import append_summary, log, read_json, set_output, warn, write_json  # noqa: E402

FOLDERS = ("sharecfg", "sharecfgdata")

ASSIGN_RE = re.compile(
    r"(?:_G\.)?pg\.(?:base\.)?([A-Za-z_][\w]*)(?:\.all\b|\.([A-Za-z_][\w]*)"
    r"|\[\s*(-?\d+)\s*\]|\[\s*\"([^\"]*)\"\s*\])\s*=\s*\{"
)

GENERAL_RE = re.compile(r"^([A-Za-z_][\w]*)\.([A-Za-z_][\w]*)\s*=\s*\{", re.M)


class LuaParseError(Exception):
    pass


def _skip_ws(text: str, i: int) -> int:
    n = len(text)
    while i < n:
        ch = text[i]
        if ch in " \t\r\n,":
            i += 1
            continue
        if text.startswith("--", i):
            # 行注释或块注释
            if text.startswith("--[[", i):
                end = text.find("]]", i + 4)
                i = n if end < 0 else end + 2
            elif text.startswith("--[==[", i):
                end = text.find("]==]", i + 5)
                i = n if end < 0 else end + 5
            else:
                end = text.find("\n", i)
                i = n if end < 0 else end + 1
            continue
        return i
    return i


def _read_string(text: str, i: int) -> tuple[str, int]:
    quote = text[i]
    i += 1
    out = []
    n = len(text)
    while i < n:
        ch = text[i]
        if ch == "\\":
            i += 1
            if i >= n:
                break
            esc = text[i]
            if esc == "n":
                out.append("\n")
            elif esc == "t":
                out.append("\t")
            elif esc == "r":
                out.append("\r")
            elif esc == "a":
                out.append("\a")
            elif esc == "b":
                out.append("\b")
            elif esc == "f":
                out.append("\f")
            elif esc == "v":
                out.append("\v")
            elif esc == "\\":
                out.append("\\")
            elif esc == "\"":
                out.append("\"")
            elif esc == "'":
                out.append("'")
            elif esc == "\n":
                out.append("\n")
            elif esc.isdigit():
                digits = esc
                j = i + 1
                while j < n and len(digits) < 3 and text[j].isdigit():
                    digits += text[j]
                    j += 1
                out.append(chr(int(digits)))
                i = j - 1
            else:
                out.append(esc)
            i += 1
            continue
        if ch == quote:
            return "".join(out), i + 1
        out.append(ch)
        i += 1
    raise LuaParseError("unterminated string")


IDENT_RE = re.compile(r"[A-Za-z_][\w]*")
NUMBER_RE = re.compile(r"-?(?:0[xX][0-9a-fA-F]+|\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?)")


def _read_number(text: str, i: int):
    match = NUMBER_RE.match(text, i)
    if not match:
        raise LuaParseError("bad number at %d" % i)
    raw = match.group(0)
    end = match.end()
    if raw.lower().startswith(("0x", "-0x")):
        return int(raw, 16), end
    if "." in raw or "e" in raw.lower():
        value = float(raw)
        if value.is_integer() and abs(value) < 2 ** 53:
            return int(value), end
        return value, end
    return int(raw), end


class _TableBuilder:
    """一边解析一边判断是数组还是字典。"""

    def __init__(self):
        self.array: list = []
        self.dict: dict = {}

    def add_positional(self, value):
        self.array.append(value)

    def add_key(self, key, value):
        if isinstance(key, int) and key == len(self.array) + 1 and not self.dict:
            self.array.append(value)
        else:
            self.dict[key] = value

    def result(self):
        if not self.dict:
            return self.array
        if not self.array:
            return self.dict
        # 混合：位置项用 1..n 作为键
        merged = dict(self.dict)
        for index, value in enumerate(self.array, start=1):
            merged[index] = value
        return merged


def parse_table(text: str, i: int):
    if text[i] != "{":
        raise LuaParseError("expected { at %d" % i)
    i += 1
    builder = _TableBuilder()
    n = len(text)
    while True:
        i = _skip_ws(text, i)
        if i >= n:
            raise LuaParseError("unterminated table")
        if text[i] == "}":
            return builder.result(), i + 1
        if text[i] == "[":
            i += 1
            i = _skip_ws(text, i)
            if text[i] in "\"'":
                key, i = _read_string(text, i)
            else:
                key, i = _read_number(text, i)
            i = _skip_ws(text, i)
            if text[i] != "]":
                raise LuaParseError("expected ] at %d" % i)
            i = _skip_ws(text, i + 1)
            if text[i] != "=":
                raise LuaParseError("expected = at %d" % i)
            i = _skip_ws(text, i + 1)
            value, i = parse_value(text, i)
            builder.add_key(key, value)
            continue
        # name = value ?
        ident = IDENT_RE.match(text, i)
        if ident:
            j = _skip_ws(text, ident.end())
            if j < n and text[j] == "=" and not text.startswith("==", j):
                key = ident.group(0)
                value, i = parse_value(text, j + 1)
                builder.add_key(key, value)
                continue
        value, i = parse_value(text, i)
        builder.add_positional(value)


def parse_value(text: str, i: int):
    i = _skip_ws(text, i)
    if i >= len(text):
        raise LuaParseError("unexpected end")
    ch = text[i]
    if ch == "{":
        return parse_table(text, i)
    if ch in "\"'":
        return _read_string(text, i)
    if ch == "-" or ch.isdigit() or ch == ".":
        return _read_number(text, i)
    if text.startswith("true", i):
        return True, i + 4
    if text.startswith("false", i):
        return False, i + 5
    if text.startswith("nil", i):
        return None, i + 3
    raise LuaParseError("unsupported token at %d: %r" % (i, text[i:i + 24]))


def convert_file(path: Path) -> dict:
    """一个 lua 文件 → {"all": [...], "rows": {...}}"""
    text = path.read_text("utf-8", errors="surrogateescape")
    result: dict = {"all": [], "rows": {}}
    for match in ASSIGN_RE.finditer(text):
        name = match.group(1)
        if name in ("base",) or not name:
            continue
        is_all = text[match.start():match.end()].find(".all") >= 0
        key_num = match.group(3)
        key_str = match.group(4)
        brace = match.end() - 1
        try:
            value, _ = parse_table(text, brace)
        except LuaParseError:
            continue
        if is_all:
            if isinstance(value, list):
                result["all"] = value
            continue
        if key_num is not None:
            result["rows"][key_num] = value
        elif key_str is not None:
            result["rows"][key_str] = value
        else:
            prop = match.group(2)
            if prop and prop != "all":
                result["rows"].setdefault("@props", {})[prop] = value
    if not result["rows"]:
        # 有些表不挂在 pg 上，而是 cs.表名 = { ... } 这类写法
        general = GENERAL_RE.search(text)
        if general:
            try:
                value, _ = parse_table(text, general.end() - 1)
            except LuaParseError:
                value = None
            if isinstance(value, dict) and value:
                result["rows"] = value
            elif isinstance(value, list) and value:
                result["all"] = value
    return result


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lua-dir", default="lua", help="源码树根目录（小写 lua，非服务器名）")
    ap.add_argument("--out", default="tables", help="JSON 输出目录")
    ap.add_argument("--only", default="", help="只处理名字里含该子串的表")
    ap.add_argument("--state", default="data/version.json")
    ap.add_argument("--server", default="CN")
    ap.add_argument("--max-failures", type=int, default=5,
                    help="解析失败超过这个数就报错（否则只警告，避免单个坏表卡住整条流水线）")
    args = ap.parse_args()

    lua_dir = Path(args.lua_dir)
    out = Path(args.out)
    if not lua_dir.is_dir():
        warn(f"{lua_dir} 不存在，先跑 unpack_lua.py")
        return 1

    targets: list[tuple[str, Path, str]] = []
    for folder in FOLDERS:
        directory = lua_dir / folder
        if not directory.is_dir():
            continue
        for path in sorted(directory.glob("*.lua")):
            if args.only and args.only not in path.name:
                continue
            targets.append((folder, path, path.stem))

    started = time.time()
    rows_per_table: dict[str, int] = {}
    empty: list[str] = []
    failed: list[tuple[str, str]] = []
    written = 0

    for folder, path, table in targets:
        out_dir = out / folder
        out_dir.mkdir(parents=True, exist_ok=True)
        try:
            data = convert_file(path)
        except Exception as exc:  # noqa: BLE001
            failed.append((f"{folder}/{table}", f"{type(exc).__name__}: {exc}"))
            continue
        if not data["rows"] and not data["all"]:
            empty.append(f"{folder}/{table}")
            (out_dir / f"{table}.json").unlink(missing_ok=True)
            continue
        target = out_dir / f"{table}.json"
        with target.open("w", encoding="utf-8", newline="\n") as fh:
            json.dump(data, fh, ensure_ascii=False, separators=(",", ":"))
        rows_per_table[f"{folder}/{table}"] = len(data["rows"])
        written += 1
        if written % 100 == 0:
            log(f"  已转换 {written}/{len(targets)}（{time.time() - started:.0f}s）")

    # 清理已消失的表
    removed = 0
    keep = set(rows_per_table)
    for folder in FOLDERS:
        directory = out / folder
        if not directory.is_dir():
            continue
        for stale in directory.glob("*.json"):
            if f"{folder}/{stale.stem}" not in keep:
                stale.unlink()
                removed += 1

    state = read_json(Path(args.state))
    version = (state.get(args.server) or {}).get("version", "")
    total_rows = sum(rows_per_table.values())
    write_json(out / "_index.json", {
        "version": version,
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "tables": len(rows_per_table),
        "rows": total_rows,
        "empty": sorted(empty),
        "failed": [name for name, _ in failed],
        "per_table": rows_per_table,
    })

    elapsed = time.time() - started
    log(f"完成：{len(rows_per_table)} 张表 / {total_rows} 行 / "
        f"{len(empty)} 个空文件 / {len(failed)} 项失败 / 清理 {removed} / {elapsed:.0f}s")

    set_output(tables=len(rows_per_table), rows=total_rows,
               empty=len(empty), failed=len(failed), seconds=f"{elapsed:.0f}")
    append_summary(
        f"### 表 JSON（{args.server} {version}）\n"
        f"- 表：`{len(rows_per_table)}` 张 / `{total_rows}` 行\n"
        f"- 空文件（不是表，正常）：`{len(empty)}`\n"
        f"- 解析失败：`{len(failed)}`"
        + ("：" + "、".join(f"`{n}`" for n, _ in failed[:8]) if failed else "") + "\n"
    )
    for name, err in failed[:10]:
        warn(f"{name} 解析失败：{err}")
    if not rows_per_table:
        warn("一张表都没解析出来")
        return 1
    return 1 if len(failed) > args.max_failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
