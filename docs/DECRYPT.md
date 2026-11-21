# 解密原理（DECRYPT.md）

本仓库从 CN 官方 CDN 一手解包，两条链路：

## 链路 A：`scripts32`（整体加密的 UnityFS）

- 握手得到 azhash → 从 CDN 下 `scripts32`（约 40 MB）
- `uabdec <in> <out>` 整体解密 → 明文 UnityFS
- UnityPy 打开，遍历 TextAsset：
  - container 形如 `assets/luabuilds/android/normal/sharecfg/xxx.lua.bytes`
  - 去掉 `assets/luabuilds/android/normal/` 前缀和 `.bytes` 后缀 = 相对路径
  - `m_Script`（UnityPy 1.10+ 已解成 str，需 `encode("utf-8","surrogateescape")` 取回原始字节）
- 每个脚本先 `bcdec`（魔改 LuaJIT 字节码 → 标准），再 `ljd.tools.process_bytes` 反编译
- 产出 `lua/<相对路径>.lua`

## 链路 B：`sharecfgdata/<表名>`（独立 bundle）

- 每个 bundle 不是 UnityFS，而是**自定义容器**：

  ```
  [uleb128 长度][LuaJIT 字节码] × N
  ```

- 逐段读出后每段前后补上 `\x1bLJ\x02\x02` 头和 `\x00` 尾，就是完整的 BC dump
- **逐段** `bcdec` + `ljd` 反编译，再把文本用 `\n` 拼起来
- 产出 `lua/sharecfgdata/<表名>.lua`

> 教训：先拼字节码再一次性反编译（三种拼法）全部失败，ljd 报
> `'NoneType' object has no attribute 'constants'`。必须逐段。

## 表 JSON（tables/）

`build_tables.py` 对 `lua/sharecfg`、`lua/sharecfgdata` 下的每个表做 Lua→JSON 解析：

- 识别 `pg.base.NAME = {...}` / `pg.NAME = {...}` / `cs.NAME = {...}` 等形态
- 合并数组部分 `all` 与字典部分 `rows`，产出 `{"all":[],"rows":{}}`
- 标量属性存成 `@props`

与上游 `AzurLaneData/public/data` 的区别：上游做了面向业务的透视（key 拆分、
字段重命名），这里是**原始形态**，`tables/_index.json` 给出统计（表数/行数/
空表/失败）与生成时间。

## 增量策略

`data/manifest.json` 记录每个 bundle 与每个脚本字节码的 md5：

- bundle md5 没变 → 整段跳过（不下载、不解密、不重写）
- 脚本字节码 md5 没变且文件还在 → 沿用仓库内 `.lua`
- 远端已消失的文件 → `prune()` 删除，保证 `lua/` 与线上完全一致
- 缓存（CI 的 `.cache/`）按 md5 分文件，跨版本复用安全

## 版本判定

- 权威：`versions/CN.txt`（写入 `unpack_lua.py`），与上游 AzurLaneLuaScripts 同款
- 每次握手得到 azhash（如 `$azhash$9$7$437$61657aa2c40e3cb1`），
  `data/version.json` 记录 `az/version/stamp/status/checked_at/generated_at`

## 手工核对

```bash
# 单个表重新解析
python scripts/build_tables.py --lua-dir lua --out /tmp/t --only ship_data_statistics

# 反编译单个 bundle（Linux）
tools/bcdec < seg.bin > seg_std.lj    # 每段
python -c "import ljd.tools; print(ljd.tools.process_bytes(open('seg_std.lj','rb').read()))"
```