"""流水线共用工具。

只用标准库：GitHub 托管 runner 上除了 requirements.txt 里的
UnityPy / ljd，不需要别的环境。
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
from pathlib import Path


# ---------------------------------------------------------------- 日志

def log(msg: str) -> None:
    print(f"[lua] {msg}", flush=True)


def warn(msg: str) -> None:
    print(f"::warning::{msg}", flush=True)


def error(msg: str) -> None:
    print(f"::error::{msg}", flush=True)


def die(msg: str, code: int = 1) -> "NoReturn":  # type: ignore[valid-type]
    error(msg)
    sys.exit(code)


# ---------------------------------------------------------------- 子进程

def sh(cmd: list[str], cwd: str | Path | None = None, check: bool = True) -> str:
    """跑一个命令，返回 stdout（去掉首尾空白）。"""
    proc = subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if proc.returncode != 0:
        if check:
            sys.stderr.write(proc.stdout or "")
            sys.stderr.write(proc.stderr or "")
            die(f"命令失败（{proc.returncode}）：{' '.join(cmd)}")
        return proc.stdout or ""
    if proc.stderr.strip():
        # git 的进度信息走 stderr，原样透出便于排查
        print(proc.stderr.rstrip(), file=sys.stderr, flush=True)
    return (proc.stdout or "").strip()


def git(*args: str, cwd: str | Path | None = None, check: bool = True) -> str:
    return sh(["git", *args], cwd=cwd, check=check)


# ---------------------------------------------------------------- JSON 读写

def write_json(path: str | Path, obj) -> None:
    """稳定格式写 JSON：键排序、不转义中文、LF 结尾，保证 diff 只反映真实变化。"""
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    tmp = p.with_suffix(p.suffix + ".tmp")
    with tmp.open("w", encoding="utf-8", newline="\n") as fh:
        json.dump(obj, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        fh.write("\n")
    tmp.replace(p)


def read_json(path: str | Path, default=None):
    p = Path(path)
    if not p.exists():
        return {} if default is None else default
    try:
        return json.loads(p.read_text("utf-8"))
    except json.JSONDecodeError:
        if default is None:
            warn(f"{p} 不是合法 JSON，按空处理")
            return {}
        return default


def write_text(path: str | Path, text: str) -> None:
    p = Path(path)
    p.parent.mkdir(parents=True, exist_ok=True)
    tmp = p.with_suffix(p.suffix + ".tmp")
    with tmp.open("w", encoding="utf-8", newline="\n") as fh:
        fh.write(text)
    tmp.replace(p)


# ---------------------------------------------------------------- Actions 交互

def set_output(**kwargs) -> None:
    """写到 $GITHUB_OUTPUT，供后续 step 读取。"""
    out = os.environ.get("GITHUB_OUTPUT")
    if not out:
        for k, v in kwargs.items():
            log(f"output {k}={v}")
        return
    with open(out, "a", encoding="utf-8") as fh:
        for k, v in kwargs.items():
            v = str(v).lower() if isinstance(v, bool) else v
            fh.write(f"{k}={v}\n")


def append_summary(markdown: str) -> None:
    path = os.environ.get("GITHUB_STEP_SUMMARY")
    if path:
        with open(path, "a", encoding="utf-8") as fh:
            fh.write(markdown + "\n")
    else:
        log(markdown)


# ---------------------------------------------------------------- 提交

def commit_and_push(
    cwd: str | Path,
    message: str,
    paths: list[str],
    branch: str | None = None,
    push: bool = True,
) -> bool:
    """只暂存明确列出的路径，避免把“工作区里没同步的旧文件”误判为删除。

    推送之后必须用 `git ls-remote` 回读远端**分支 SHA** 并等于本地 HEAD 才算成功。
    教训（首轮 CI 实测）：不要在 commit **之前**取各路径的 blob sha 去比，
    拿旧内容去比新提交必然“不一致”；也不要只信 `git push` 的返回值 ——
    rebase 把提交丢掉时它依旧返回 0。比 commit sha 最直接，同一个
    commit sha 就必然同内容。
    """
    cwd = Path(cwd)
    branch = branch or os.environ.get("GITHUB_REF_NAME") or git(
        "rev-parse", "--abbrev-ref", "HEAD", cwd=cwd
    )

    for p in paths:
        git("-c", "core.quotepath=false", "add", "-A", "--", p, cwd=cwd)
    if not git("diff", "--cached", "--name-only", cwd=cwd):
        log("没有内容变化，跳过提交")
        return False

    changed = git("diff", "--cached", "--name-only", cwd=cwd).splitlines()
    log(f"变更 {len(changed)} 个文件，示例：{changed[:5]}")

    git("-c", "user.name=github-actions[bot]",
        "-c", "user.email=41898282+github-actions[bot]@users.noreply.github.com",
        "commit", "-q", "-m", message, cwd=cwd)

    if not push:
        log("--no-push：已提交，未推送")
        return True

    for attempt in range(1, 4):
        head = git("rev-parse", "HEAD", cwd=cwd).strip()
        proc = subprocess.run(
            ["git", "push", "-q", "origin", f"HEAD:{branch}"],
            cwd=str(cwd), capture_output=True, text=True,
            encoding="utf-8", errors="replace",
        )
        if proc.returncode == 0:
            remote = git("ls-remote", "origin", f"refs/heads/{branch}",
                         cwd=cwd, check=False).split()
            remote_sha = remote[0] if remote else ""
            if remote_sha == head:
                log(f"已推送到 {branch}（远端 {remote_sha[:8]} == 本地 HEAD {head[:8]}）")
                return True
            warn(f"push 返回 0，但远端 {branch} 是 "
                 f"{remote_sha[:8] or '?'}，本地 HEAD 是 {head[:8]}（{attempt}/3）")
        else:
            warn(f"推送失败（{attempt}/3）：{(proc.stderr or '').strip()[:400]}")
        if attempt == 3:
            die(f"推送后校验未通过：远端 {branch} 不是本地 HEAD {head[:8]}，请人工检查")
        git("pull", "--rebase", "--autostash", "-q", "origin", branch,
            cwd=cwd, check=False)
    return True
    return True
