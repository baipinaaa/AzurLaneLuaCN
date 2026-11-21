"""版本比对：决定这一轮要不要真的解包。

为什么单独一步：
    解包 + 反编译是整个链路最贵的部分（39MB 字节码、四万多个脚本文件）。
    而检查版本只需要一次 TCP 握手，几百毫秒。所以定时的 cron 先问一句
    "变了吗"，没变就直接结束。

判据用 azhash：
    它是资源清单的版本号，任何一次热更都会变，`scripts32` 和
    `sharecfgdata/*` 都在 az 清单里，所以它一个就够。

⚠️ 这里**只读**不写：版本状态由 unpack_lua.py 在真正跑完之后才落盘。
   否则中途崩了也会把新版本记成"已处理"，下一轮永远不重试。

用法：
    python scripts/check_version.py --server CN --state data/version.json
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _common import log, read_json, set_output, warn  # noqa: E402
from cdn import azhash_of, get_version  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--server", default="CN")
    ap.add_argument("--state", required=True, help="版本状态文件，如 data/version.json")
    args = ap.parse_args()

    raw, version, stamp = azhash_of(get_version(args.server))

    state = read_json(args.state)
    prev = (state.get(args.server) or {})
    changed = prev.get("az") != raw
    prev_version = prev.get("version") or ""

    log(f"{args.server} azhash {version} ({stamp})"
        + (" —— 未变化" if not changed else f" —— 有更新（当前记录 {prev_version or '无'}）"))

    set_output(changed="true" if changed else "false",
               version=version, stamp=stamp, az=raw, prev=prev_version)
    if not changed and prev.get("status") and prev["status"] != "ok":
        warn(f"上一轮状态是 {prev['status']}，需要 --force 才会重跑")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
