# 架构说明（ARCHITECTURE.md）

## 数据流

```
每天 UTC 0:00（cron）
   │
   ├─ check_version.py    一次 TCP 握手，azhash 没变 → 收工
   │
   ├─ unpack_lua.py       版本变了才跑（完整 ~40-50min）
   │     ├─ 下载 scripts32 → uabdec → UnityPy 遍历 → 逐脚本 bcdec+ljd → lua/*
   │     ├─ 下载 32 个 sharecfgdata bundle → 逐段 bcdec+ljd → lua/sharecfgdata/*
   │     ├─ prune 清理远端已删的 .lua
   │     ├─ 写 data/manifest.json、data/version.json、versions/CN.txt
   │
   ├─ build_tables.py     lua/sharecfg + lua/sharecfgdata → tables/*.json + _index.json
   │
   └─ commit.py           只 add lua/ tables/ data/ versions/，push 后回读远端校验
```

## 脚本职责

| 脚本 | 职责 |
|---|---|
| `scripts/_common.py` | 日志 / 子进程 / JSON 读写 / GITHUB_OUTPUT / 提交推送 |
| `scripts/cdn.py` | 握手（proto 解析）、清单、下载（.part + size 校验） |
| `scripts/check_version.py` | 版本比对（只读），决定本轮是否重跑 |
| `scripts/unpack_lua.py` | 解包主流程（scripts32 + sharecfgdata + prune） |
| `scripts/build_tables.py` | Lua 配置表 → JSON |
| `scripts/commit.py` | 提交并推送（可 `--no-push`） |

## 状态机（data/version.json）

```json
{
  "CN": {
    "az": "$azhash$...",
    "version": "9.7.437",
    "stamp": "61657aa2c40e3cb1",
    "status": "ok" | "partial",
    "checked_at": "2026-11-19T03:39:06Z",
    "generated_at": "..."
  }
}
```

- `status=ok` → 提交（workflow 里 `steps.unpack.outputs.status == 'ok'`）
- `status=partial` → **不提交**，仓库保持旧版，下一轮 auto 重试
- 失败数超过 `--max-failures`（unpack 默认 50，build 默认 5）→ 直接 die，job 失败

## 提交与推送（commit_and_push）

- 只 `git add -A -- <paths>`（`lua/ tables/ data/ versions/`），不做 `git add -A .`
- 提交身份：`github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>`
- 推送后**回读远端 tree sha** 校验与本地一致（克服 `git pull --rebase` 丢提交但
  `git push` 仍返回 0 的坑），失败重试 3 次 + `pull --rebase --autostash`

## 增量（没有 actions/cache）

本仓库**不用 GitHub Actions 缓存**：上一轮的解包产物（`lua/` 四万多个文件）
和 `data/manifest.json`（bundle / 脚本字节码的 md5 索引）**通过 git 提交**，
下一轮 checkout 出来就是增量基线。

- bundle md5 没变 → 整段跳过（不下载、不解密、不重写）
- 脚本字节码 md5 没变且文件还在 → 沿用仓库内 `.lua`，不重新反编译
- 远端已消失的 → `prune()` 删除，保证 `lua/` 与线上完全一致
- 缓存驱逐 / 换 runner / 换新 runner 都不丢状态，因为增量跟随仓库走

代价：`lua/`（约 450 MB）+ `tables/` 都进 git，仓库体量较大，但这是
「每小时拉一次」需求里最省事的做法 —— 版本没变的轮次只做一次握手就结束。

## 只做 CN

- `SERVERS` 里只有 `CN` 一项（`line1-login-bili-blhx.bilibiligame.net`）
- 渠道服（华为/小米/OPPO/vivo……）不在支持范围

## 为什么这么设计

- **24h 而不是每小时**：用户要求每 24 小时拉取；CN 热更频率通常数天一更，
  日粒度够用，且 cron 空跑成本极低（一次握手）
- **azhash 判据**：单次热更任何 bundle 都可能变，azhash 一次覆盖
- **不提交 partial**：避免把"部分失败"的半成品当正式版本发布出去
- **提交信息**：`update [CN]: 旧 -> 新`，与上游 AzurLaneLuaScripts 保持一致