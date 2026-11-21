"""CN 服（哔哩哔哩服）登录服握手 + CDN 清单 + bundle 下载。

为什么自己握手而不用现成仓库：
    这样数据新鲜度只取决于游戏自己，链路里没有第三方仓库。

流程（实测可用）：
    1. TCP 连登录服，发一段固定 protobuf 请求
    2. 回包里 version 字段是若干 `$xxxhash$a$b$c$md5$` 字符串
       `$azhash$` 就是资源清单版本号（脚本、配置表、图片全都算在内）
    3. <cdn>/android/hash/<azhash>      → 每行 `path,size,md5` 的全量清单
    4. <cdn>/android/resource/<md5>     → bundle 本体

只有 CN。渠道服（tap / 各应用商店）走的是不同的登录服与 CDN，
本仓库按需求不支持 —— 需要时在 SERVERS 里加一条，并自行确认能连通。
"""

from __future__ import annotations

import socket
import time
import urllib.error
import urllib.request
from pathlib import Path

from _common import die, log, warn

# (登录服 host, port, CDN 根)
SERVERS = {
    'CN': ('line1-login-bili-blhx.bilibiligame.net', 80,
           'https://line3-patch-blhx.bilibiligame.net'),
}

# sc_10801 请求体，固定 11 字节
SEND_PAYLOAD = bytes.fromhex('000a002a300000082d120130')

# 回包字段表。未知字段一律跳过 —— 2026 的协议比 2023 多了字段 10，
# 旧代码在这里直接 KeyError。
FIELDS = {
    1: ('gateway_ip', 9),
    2: ('gateway_port', 13),
    3: ('url', 9),
    4: ('version', 9),
    5: ('proxy_ip', 9),
    6: ('proxy_port', 13),
    7: ('is_ts', 13),
    8: ('timestamp', 13),
    9: ('monday_0oclock_timestamp', 13),
}

UA = {'User-Agent': 'Mozilla/5.0 (compatible; azl-lua/1.0)'}


# ------------------------------------------------------------------ protobuf

def _read_varint(buf: bytes, i: int):
    shift = result = 0
    while True:
        b = buf[i]
        i += 1
        result |= (b & 0x7F) << shift
        shift += 7
        if not b & 0x80:
            return result, i


def _parse_proto(data: bytes) -> dict:
    out: dict = {}
    i, n = 0, len(data)
    while i < n:
        num, i = _read_varint(data, i)
        wtyp = num & 7
        num >>= 3
        if wtyp == 0:
            val, i = _read_varint(data, i)
        elif wtyp == 2:
            size, i = _read_varint(data, i)
            val = data[i:i + size]
            i += size
        elif wtyp == 1:
            val = data[i:i + 8]
            i += 8
        elif wtyp == 5:
            val = data[i:i + 4]
            i += 4
        else:
            raise ValueError(f'未知 wire type {wtyp}')
        if num not in FIELDS:
            continue
        name, typ = FIELDS[num]
        if typ == 9 and isinstance(val, bytes):
            val = val.decode('u8', 'replace')
        if num == 4:
            out.setdefault(name, []).append(val)
        else:
            out[name] = val
    return out


# ------------------------------------------------------------------ 握手

def get_version(server: str) -> dict:
    """登录服握手，返回 {'apk_url': ..., 'versions': {类型: {'version','raw'}}}"""
    if server not in SERVERS:
        die(f'只支持 {", ".join(SERVERS)}，{server} 不在名单里（渠道服不拉取）')
    host, port, _cdn = SERVERS[server]
    log(f'连接登录服 {host}:{port}')
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(15)
        s.connect((host, port))
        s.send(SEND_PAYLOAD)
        raw = s.recv(20480)
    if not raw:
        die('登录服没有返回数据')
    info = _parse_proto(raw[7:])
    result = {'apk_url': info.get('url', ''), 'versions': {}}
    for item in info.get('version', []):
        if not item.startswith('$'):
            continue
        parts = item.strip('$').split('$')
        key = parts[0]
        if key.endswith('hash'):
            key = key[:-4]
        ver = '.'.join((['0', '0', '0'] + parts[1:-1])[-3:])
        result['versions'][key] = {'version': ver, 'raw': item}
    return result


def azhash_of(info: dict) -> tuple[str, str, str]:
    """从握手结果里取 (azhash 原文, 版本号, stamp)。"""
    az = (info.get('versions') or {}).get('az') or {}
    raw = az.get('raw') or ''
    if not raw.startswith('$azhash'):
        die('版本信息里没有 azhash，无法解包')
    parts = raw.strip('$').split('$')
    version = '.'.join((['0', '0', '0'] + parts[1:-1])[-3:])
    stamp = parts[-1] if len(parts) > 1 else ''
    return raw, version, stamp


# ------------------------------------------------------------------ HTTP

def http_get(url: str, retries: int = 3, timeout: int = 60) -> bytes:
    last = None
    for attempt in range(1, retries + 1):
        try:
            req = urllib.request.Request(url, headers=UA)
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                return resp.read()
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            last = exc
            if attempt < retries:
                time.sleep(2 * attempt)
    raise RuntimeError(f'下载失败 {url}: {last}')


def fetch_hash_list(cdn: str, raw: str) -> dict:
    """全量清单：path -> {'size','md5'}"""
    data = http_get(f'{cdn}/android/hash/{raw}', timeout=180)
    res = {}
    for line in data.decode('u8', 'replace').splitlines():
        if not line:
            continue
        try:
            path, size, md5 = line.split(',')
        except ValueError:
            continue
        res[path] = {'size': int(size), 'md5': md5}
    if not res:
        die('az 清单为空')
    return res


def download_bundle(cdn: str, md5: str, dest: Path, expect_size: int | None = None) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + '.part')
    tmp.write_bytes(http_get(f'{cdn}/android/resource/{md5}', timeout=300))
    if expect_size and tmp.stat().st_size != expect_size:
        size = tmp.stat().st_size
        tmp.unlink()
        raise RuntimeError(f'大小不符 {dest.name}: 期望 {expect_size}，实得 {size}')
    tmp.replace(dest)


def fetch_bundle(cdn: str, listing: dict, path: str, dest: Path, reuse: bool = True) -> Path:
    """按清单下载一个 bundle，已存在且大小一致就复用。"""
    meta = listing[path]
    if reuse and dest.exists() and dest.stat().st_size == meta['size']:
        return dest
    if dest.exists():
        warn(f'{path} 本地大小不符，重新下载')
    download_bundle(cdn, meta['md5'], dest, meta['size'])
    return dest
