# 排障（TROUBLESHOOTING.md）

## bcdec / uabdec 是 32 位 ELF，Windows 跑不了

`tools/bcdec`、`tools/uabdec` 是**静态链接的 32 位 i386 Linux ELF**。
Windows 本机（无 WSL / WSL 未装）无法直接执行：

```bash
wsl.exe --status   # 若输出 "未安装"，说明本机没有 WSL
```

- 要么装 WSL 后在 WSL 里跑
- 要么只在 GitHub Actions（ubuntu-latest）上跑
- 不要在 Windows cmd/PowerShell 里直接 `tools\bcdec`，会报 `不是有效的 Win32 应用程序`

在 ubuntu runner 上**不需要** `libc6:i386`，静态链接直接就能跑
（已验证：`chmod +x` 后空输入 `bcdec </dev/null` 返回非 0 属正常）。

## 缺 ljd

```text
缺少 ljd，请 pip install https://github.com/AzurLaneTools/ljd/releases/download/wheel/ljd-0.1.7-py3-none-any.whl
```

`ljd` 没有 PyPI 版，必须用该 wheel。`requirements.txt` 已带。

## ljd 报 `'NoneType' object has no attribute 'constants'`

原因：把多个片段拼成一段字节码再一次性反编译。**必须逐段**反编译再拼文本。
`unpack_lua.py` 的 `unpack_sharecfgdata()` 已经是对的，不要改回整包拼。

## 失败项很多 / 状态 partial

- `unpack_lua.py` 每项失败会记进 `failures`，超过 `--max-failures`（默认 50）直接 die，本轮不提交
- `status=partial` 时 workflow 不提交，下一轮 cron 会自动重试
- 排查：看 job 日志里 `::warning::<rel> 失败：<error>`，常见原因：
  - 单个 bundle 下载中断（`.part` 会校验 size，不匹配会重试）
  - bcdec 对个别魔改字节码返回非 0（少见；可换新 commit 的 bcdec）

## 有缓存但没命中 / 缓存配额

- 版本没变的轮次不恢复缓存（key 在版本比对之后）——这是故意的，避免刷配额
- 缓存 key `lua-CN-<stamp>`，restore-keys `lua-CN-` 会复用上一版
- 若怀疑缓存坏了：`workflow_dispatch` 手动触发一次，勾 `force` 全量重解

## 推送被拒 / 回读校验失败

`commit_and_push` 会 `pull --rebase --autostash` 后重试 3 次，再不行就 die。
这种情况通常是有别的分支在推进（比如手动改过仓库），人工检查即可。

## 手动重跑单个表

```bash
python scripts/build_tables.py --lua-dir lua --out /tmp/t --only ship_data_statistics
```

## 常见疑问

- **为什么只有 `scripts32` 没有 `scripts64`？** CN 的 64 位包（scripts64）
  也在清单里，但解 `scripts32` 已经能得到完整源码树（上游 AzurLaneData 也是
  只解 32 位）；两个包内容等价，我们只处理 32。
- **为什么 sharecfgdata 不在 scripts32 里？** sharecfgdata 是独立 bundle，
  清单里单独列（`sharecfgdata/<表名>` 32 个）。两条链路都要跑。
- **渠道服在哪配？** 本仓库只支持 CN（bilibili 服），`scripts/cdn.py` 只有
  `CN` 一项。渠道服的域名/握手协议不同，不支持。