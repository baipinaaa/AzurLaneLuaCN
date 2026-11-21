# AzurLaneLuaCN

从碧蓝航线 **CN 服（bilibili 服）官方 CDN** 一手解包出的 **Lua 源码仓库**，每日自动更新。

- `lua/` —— 完整可读的 Lua 源码（与线上脚本一一对应，含 `sharecfg` / `sharecfgdata` / `gamecfg` / `view` 等）
- `tables/` —— 把配置表（`sharecfg`、`sharecfgdata`）批量解析成的 **JSON**，附 `_index.json` 全局索引
- `data/version.json` —— 当前版本 / azhash / 状态
- `versions/CN.txt` —— 当前客户端版本号（与上游 `AzurLaneLuaScripts/versions/CN.txt` 同款，是判断配置版本的权威值）

## 更新频率

GitHub Actions 每天 UTC 0 点自动检查：

- 版本（azhash）没变 → 只做一次握手就结束，不产生提交
- 版本变了 → 解包 `scripts32`（整体加密的 UnityFS）+ 32 个 `sharecfgdata` bundle → 反编译 → 构建表 → 提交

提交信息沿用上游格式：`update [CN]: 9.7.434 -> 9.7.437`

也可在 Actions 页面手动触发（`workflow_dispatch`）：
- `force`：忽略版本比对强制全量重解
- `dry_run`：只跑不提交（验证用）

## 目录结构

```
scripts/        python 流水线（见 docs/ARCHITECTURE.md）
tools/          bcdec / uabdec（来自 AzurLaneExtractor，静态 32 位 ELF）
docs/           解码原理（DECRYPT.md）、架构（ARCHITECTURE.md）、排障（TROUBLESHOOTING.md）
lua/            解包后的源码（由 CI 生成，不手改）
tables/         表 JSON（由 CI 生成，不手改）
data/           版本与状态
versions/       客户端版本号
```

## 快速开始

```bash
# 本地跑（需要 Linux 或能在 Linux 二进制上跑的 bash/WSL + Python 3.11）
pip install -r requirements.txt
chmod +x tools/bcdec tools/uabdec

# 检查版本
python scripts/check_version.py --server CN --state data/version.json

# 解包（完整跑一次约 40-50 分钟）
python scripts/unpack_lua.py --server CN --work .cache/work

# 构建表
python scripts/build_tables.py --lua-dir lua --out tables --server CN

# 提交（--no-push 只提交不推送）
python scripts/commit.py --message "test" --no-push
```

> 注意：`bcdec` / `uabdec` 是 32 位 Linux ELF，Windows 本机（无 WSL）跑不了，
> 本地缺 `ljd` 时 `unpack_lua.py` 会在 `decompile()` 处报错。全部逻辑以 GitHub
> Actions（ubuntu-latest）为准。

## 只做 CN（bilibili）服

本仓库**只**拉取 `SERVERS['CN']`（`line1-login-bili-blhx.bilibiligame.net`）。
渠道服（华为 / 小米 / OPPO / vivo 等）不在清单里，不需要碰。判断版本请认准
`versions/CN.txt`。想扩服只需在 `scripts/cdn.py` 的 `SERVERS` 里加一项。

## 其它

- 表 JSON 的字段结构与上游 `AzurLaneTools/AzurLaneData` 的 `public/data` 不同：
  本仓库保持 `{"all":[],"rows":{}}` 原始形态 + `@props` 标量，未做面向业务的
  透视（详见 docs/DECRYPT.md）。
- 建仓库时只需把 `lua/ tables/ data/ versions/` 四个顶层目录以正常 git 方式提交；
  `.work/ .cache/ __pycache__/` 不进仓库。