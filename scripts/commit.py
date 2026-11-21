#!/usr/bin/env python3
"""提交并推送本轮产物。

只 add 明确列出的顶层路径（`lua/ tables/ data/ versions/`），
不做 `git add -A .` —— 免得把 `.work/` 里的中间文件带进仓库。

用法：
    python scripts/commit.py --message "update [CN]: 9.7.434 -> 9.7.437"
    python scripts/commit.py --message "..." --no-push
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from _common import commit_and_push, log, set_output  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--message", required=True)
    ap.add_argument("--paths", default="lua,tables,data,versions")
    ap.add_argument("--branch", default="")
    ap.add_argument("--no-push", action="store_true")
    args = ap.parse_args()

    cwd = Path.cwd()
    paths = [p.strip() for p in args.paths.split(",") if p.strip()]
    missing = [p for p in paths if not (cwd / p).exists()]
    if missing:
        log(f"跳过不存在的路径：{', '.join(missing)}")
        paths = [p for p in paths if p not in missing]

    committed = commit_and_push(cwd, args.message, paths,
                                branch=args.branch or None,
                                push=not args.no_push)
    set_output(committed="true" if committed else "false")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
