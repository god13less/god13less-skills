---
name: siyuan-sisyphus-llm-wiki
description: >
  在思源笔记中复现 Karpathy 的 LLM Wiki 工作流。
  通过 siyuan-sisyphus CLI 让 AI Agent 维护结构化知识库，支持来源摘要、实体页、概念页、
  综合分析和双向链接。利用思源原生 SQL 查询、反链和块级引用实现精细的知识管理。
  当用户提到 LLM Wiki、知识库构建、结构化笔记、wiki 整理、来源摘要、实体页、概念页、
  跨来源分析、知识复利增长，或需要将散乱信息整理为结构化知识网络时触发。
---

# SiYuan LLM Wiki（基于 sisyphus CLI）

将 Karpathy 的 LLM Wiki 模式迁移到思源笔记，用 `siyuan-sisyphus` CLI 作为统一操作层。

> 不要把 LLM 当搜索引擎用，而是让它像程序员写代码一样，帮你持续维护一个结构化知识库。

- **你负责**：找资料、提好问题、做判断
- **Agent 负责**：总结、交叉引用、分类整理、保持一致性
- **思源负责**：存储、链接、查询、可视化

## 前置条件

1. `siyuan-sisyphus` CLI 已配置好 profile（参考 `siyuan-sisyphus-system-cli`）
2. 思源笔记已创建笔记本（如 `LLM-Wiki`）

验证连接：

```bash
siyuan-sisyphus system get-version
siyuan-sisyphus notebook list --json
```

## 知识库目录结构

在思源笔记本下维护以下目录：

```
LLM-Wiki/
├── 📥 raw/                    # 原始资料收件箱（用户放入）
├── 📄 sources/                # 来源摘要（每篇原始资料一篇）
├── 🏢 entities/               # 实体页（人、组织、产品、工具）
├── 💡 concepts/               # 概念页（思想、框架、理论）
├── 🔗 syntheses/              # 综合页（跨领域分析、对比、主题）
├── 📋 index.md                # 主索引（自动维护）
└── 📝 log.md                  # 操作日志（只追加）
```

## 核心工作流

### 工作流 1：Ingestion（吸收资料）

当用户提供资料时执行：

**Step 0：读取资料**

```bash
# 如果资料是思源文档
siyuan-sisyphus fs read --path "/LLM-Wiki/raw/some-article"
# 如果是本地文件
siyuan-sisyphus file extract-doc --id "<doc-id>" --output-dir "/tmp/extract" --json
```

**Step 1：分析**

提取标题、作者、日期、核心观点，识别涉及的所有实体和概念，判断与现有知识库的关联。

**Step 2：创建 Source 页**

```bash
siyuan-sisyphus fs write --path "/LLM-Wiki/sources/<slug>" --markdown "# <标题>

## 元信息
- **类型**: <文章|论文|视频|推文|书籍|笔记>
- **来源**: <原始链接>
- **作者**: ((<实体块ID> "作者名"))
- **日期**: <发布日期>
- **收录日期**: <今天>
- **标签**: #来源# #标签1# #标签2#

## 精华摘要
<100-200 字精华摘要>

## 核心要点
1. <要点 1>
2. <要点 2>

## 关键引用
> <原文最有价值的段落>

## 相关链接
- ((<概念块ID> "相关概念"))
- ((<实体块ID> "相关实体"))

## 个人批注
<用户的想法、疑问 —— 不自动修改此区域>"
```

**Step 3：更新/创建 Entity 页**

对每个实体，先搜索是否已存在：

```bash
# 搜索已有实体
siyuan-sisyphus search fulltext --query "<实体名>" --parent-path "/LLM-Wiki/entities" --json
# 或用 SQL
siyuan-sisyphus search query-sql --stmt "SELECT id, content, path FROM blocks WHERE path LIKE '/LLM-Wiki/entities/%' AND content LIKE '%<实体名>%' LIMIT 10" --json
```

不存在则创建：

```bash
siyuan-sisyphus fs write --path "/LLM-Wiki/entities/<slug>" --markdown "# <实体名称>

## 元信息
- **类型**: <人物|组织|产品|工具|论文>
- **一句话描述**: <30 字内>
- **首次提及**: ((<来源块ID> "来源"))
- **标签**: #实体# #分类#

## 概述
<背景、核心贡献>

## 关键关联
- **代表作品**: ((<块ID> "产品/论文"))
- **相关人物**: ((<块ID> "实体"))

## 在知识库中的出现
- ((<块ID> "来源 1")) — <上下文>"
```

存在则追加新信息：

```bash
siyuan-sisyphus block append --parent-id "<实体文档ID>" --data-type markdown --data '
## 补充信息（来自 ((<来源块ID> "来源"))

<新发现的信息>

- **新关联**: ((<实体块ID> "实体名称"))'
```

**Step 4：更新/创建 Concept 页**

类似 Entity 的处理逻辑。创建模板参考 `templates/sy-concept.md`。

**Step 5：建立双向链接**

用 `((块ID "别名"))` 建立**真正的块引用**（`[[wikilink]]` 和 `siyuan://` 协议链接不产生 refs 记录）：

- 从 Source → Entity/Concept：追加 `((<目标块ID> "名称"))` 引用
- 从 Entity/Concept → Source：追加 `((<来源块ID> "名称"))` 引用

```bash
# 在 Source 文档中追加实体引用（用单引号包裹避免 shell 解析）
siyuan-sisyphus block append --parent-id "<source文档ID>" \
  --data-type markdown \
  --data '相关实体：((<entity块ID> "实体名"))'

# 在 Entity 文档中反向追加来源引用
siyuan-sisyphus block append --parent-id "<entity文档ID>" \
  --data-type markdown \
  --data '首次提及：((<source块ID> "来源标题"))'
```

**创建后必须校验**：

```bash
# 验证：查目标块的真引用是否建立
siyuan-sisyphus search get-backlinks --id "<目标块ID>" --mode links
# ✅ Backlinks 中出现新引用 → 成功
# ❌ 空或在 Backmentions 中 → 未建立真引用，用 block replace 重试

# 检查无效引用
siyuan-sisyphus search list-invalid-refs
```

**Step 6：更新 Index**

```bash
# 先读取 index
siyuan-sisyphus fs read --path "/LLM-Wiki/index"
# 在最近收录区追加
siyuan-sisyphus block append --parent-id "<index文档ID>" --data-type markdown \
  --data "1. ((<source块ID> \"来源标题\")) — <一句话摘要>"
```

**Step 7：记录 Log**

```bash
siyuan-sisyphus block prepend --parent-id "<log文档ID>" --data-type markdown \
  --data "- [HH:MM] [ingest] 收录来源：((<source块ID> \"来源标题\")) — <说明>"
```

---

### 工作流 2：Query（查询知识）+ 记忆反写

**Step 1：全文检索**

```bash
siyuan-sisyphus search fulltext --query "<关键词>" --page-size 20 --json
```

**Step 2：SQL 精确检索**

```bash
siyuan-sisyphus search query-sql --stmt "SELECT id, content, path FROM blocks WHERE content LIKE '%<关键词>%' AND path LIKE '/LLM-Wiki/%' AND type IN ('p','h') ORDER BY updated DESC LIMIT 20" --json
```

**Step 3：读取内容**

```bash
siyuan-sisyphus fs read --path "/LLM-Wiki/sources/<slub>"
siyuan-sisyphus block get-kramdown --id "<块ID>"
```

**Step 4：综合回答**

基于检索内容回答问题，标注来源。

**Step 5：判断是否需要记忆反写**

满足以下任一条件即保存：

| 条件 | 说明 |
|------|------|
| 涉及 2+ 来源的综合分析 | 跨文档对比、整合、矛盾分析 |
| 发现了新连接 | wiki 中未记录的关联 |
| 发现了矛盾 | 新信息与已有知识冲突 |
| 用户明确要求保存 | "记下来" / "保存" |
| 答案非显而易见 | 需推理才能得出 |
| 涉及决策或判断 | 综合判断、方案对比 |

**Step 6：创建 Synthesis 页**

```bash
siyuan-sisyphus fs write --path "/LLM-Wiki/syntheses/<slug>" --markdown "# <问题简短标题>

## 元信息
- **类型**: 综合
- **来源查询**: <用户的原始问题>
- **创建日期**: <今天>
- **置信度**: <高|中|低>
- **标签**: #综合# #主题#

## 问题
<用户的原始问题>

## 分析过程
<如何得出答案，引用哪些来源>

## 结论
<最终答案>

## 来源依据
- ((<source块ID> "来源 1")) — <具体引用>
- ((<source块ID> "来源 2")) — <具体引用>

## 后续问题
- <新问题>"
```

**Step 7：更新 Index 和 Log**

---

### 工作流 3：Lint（健康检查）

定期执行（建议每周一次）：

**检查孤立页面**

```bash
# 用反链检测：找出 entities/ 下被引用最少的文档
siyuan-sisyphus search query-sql --stmt "SELECT b.id, b.content, b.path FROM blocks b WHERE b.path LIKE '/LLM-Wiki/entities/%' AND b.type = 'd' AND b.id NOT IN (SELECT DISTINCT defBlockID FROM refs WHERE defBlockPath LIKE '/LLM-Wiki/%') LIMIT 20" --json
```

**检查无效引用**

```bash
siyuan-sisyphus search list-invalid-refs --json
```

**检查重复概念**

```bash
siyuan-sisyphus search query-sql --stmt "SELECT content, COUNT(*) as cnt FROM blocks WHERE (path LIKE '/LLM-Wiki/entities/%' OR path LIKE '/LLM-Wiki/concepts/%') AND type = 'd' GROUP BY content HAVING cnt > 1 LIMIT 20" --json
```

**统计知识库概况**

```bash
siyuan-sisyphus search query-sql --stmt "SELECT CASE WHEN path LIKE '/LLM-Wiki/sources/%' THEN 'sources' WHEN path LIKE '/LLM-Wiki/entities/%' THEN 'entities' WHEN path LIKE '/LLM-Wiki/concepts/%' THEN 'concepts' WHEN path LIKE '/LLM-Wiki/syntheses/%' THEN 'syntheses' ELSE 'other' END as doc_type, COUNT(*) as count FROM blocks WHERE path LIKE '/LLM-Wiki/%' AND type = 'd' GROUP BY doc_type" --json
```

**更新 Index**

根据统计结果更新 index.md 的文档数量。

---

## 文档模板

所有模板位于 `templates/` 目录，创建文档时遵循对应结构：

| 模板 | 用途 | 路径 |
|------|------|------|
| `sy-source.md` | 来源摘要 | `/LLM-Wiki/sources/<slug>` |
| `sy-entity.md` | 实体页 | `/LLM-Wiki/entities/<slug>` |
| `sy-concept.md` | 概念页 | `/LLM-Wiki/concepts/<slug>` |
| `sy-synthesis.md` | 综合页 | `/LLM-Wiki/syntheses/<slug>` |
| `sy-index.md` | 主索引 | `/LLM-Wiki/index` |
| `sy-log.md` | 操作日志 | `/LLM-Wiki/log` |

创建文档时使用模板结构，用 `siyuan-sisyphus fs write` 写入。

## 链接语法与反链

### 三种链接对比（实测结论）

| 语法 | 示例 | Backlink | 说明 |
|------|------|:---:|------|
| `((块ID "别名"))` | `((2026...0a6wkzt "PKU文件整理法"))` | ✅ 真引用 | **唯一建立 refs 记录的方式** |
| `[文本](siyuan://blocks/ID)` | `[PKU](siyuan://blocks/2026...0a6wkzt)` | ❌ 仅提及 | 创建可点击超链接，不建引用 |
| `[[文档名]]` | `[[PKU文件整理法]]` | ❌ 仅提及 | Wiki 链接，不建引用 |

> **核心结论**：只有 `((块ID))` 格式能建立真正的双向链接。`siyuan://` 协议链接和 `[[wikilink]]` 仅在文本中被提及（backmention），不产生 `refs` 表记录。

### ⚠️ 引用目标选择（关键！）

**绝不引用文档根块 ID**。`((文档根块ID "名称"))` 会把**整篇文档全文嵌入**当前页面，造成：
- 源文档末尾出现大段嵌入内容
- 双向引用导致循环嵌套
- 阅读体验极差

**正确做法：引用文档内的具体段落块**，如标题块（h1）或摘要块（p），只嵌入该段落而非全文。

```bash
# ❌ 错误：引用文档根块 → 嵌入全文
((20260611225828-0wk4pmq "PKU文件整理法"))

# ✅ 正确：引用文档内的标题块 → 只嵌入标题行
((20260611232042-jcw5e4s "PKU文件整理法"))
```

**获取标题块 ID 的方法**：

```bash
# 1. 用 document get-child-blocks 列出文档内所有块，取第一个 h1
siyuan-sisyphus document get-child-blocks --id "<文档ID>" --json

# 2. 或用 search fulltext 按标题文本搜索
siyuan-sisyphus search fulltext --query "PKU文件整理法" --type-shortcodes h --parent-path "/LLM-Wiki/concepts/PKU文件整理法" --json
```

### 创建链接

创建块引用链接（推荐）：

```bash
# 用单引号包裹避免 shell 解析 (( ))
siyuan-sisyphus block append --parent-id "<文档ID>" \
  --data-type markdown \
  --data '参见 ((20260611232042-jcw5e4s "PKU文件整理法")) 概念页。'
```

### 替换已有 wiki 链接

将 `[[wikilink]]` 批量替换为 `((块ID))` 引用：

```bash
# ❌ search find-replace 和 fs replace 对多数块无效
# ✅ 用 block replace 逐块替换
siyuan-sisyphus block replace --id "<含wikilink的块ID>" \
  --edit-json '{"old":"[[PKU文件整理法]]","new":"((20260611181332-0a6wkzt \"PKU文件整理法\"))"}'
```

### 创建后校验（必须！）

**每次创建或替换链接后，必须执行反链校验**，确认引用关系已建立：

```bash
# 验证：查目标块的 backlinks
siyuan-sisyphus search get-backlinks --id "<目标块ID>" --mode links
```

**校验标准**：
- ✅ Backlinks 中出现新创建的引用 → 成功，真引用已建立
- ❌ Backlinks 为空或未出现新引用 → 失败，需用 `block replace` 重试
- ⚠️ 仅在 Backmentions 中出现 → `[[wikilink]]` 或 `siyuan://` 格式，**不是真引用**，需改为 `((块ID))`

**验证残留 wiki 链接**：

```bash
# 检查是否还有未替换的 [[
siyuan-sisyphus search query-sql \
  --stmt "SELECT id, hpath FROM blocks WHERE box='<notebook-id>' AND content LIKE '%[[%'" 2>&1
```

## 命名规范

### Slug 规则
- 全部小写，空格换连字符 `-`
- 去掉中英文标点
- 保留字母、数字、中文、连字符
- 示例：`LLM Wiki 模式` → `llm-wiki模式`

### 标签规范
- 使用思源行级标签 `#标签名#`
- 常用标签：`#来源#` `#实体#` `#概念#` `#综合#` `#重要#` `#待办#`

## 最佳实践

1. **幂等性**：创建前先搜索，避免重复
2. **追加而非覆盖**：更新已有文档时用 `block append` 而非重写
3. **保留用户内容**：`raw/` 和"个人批注"区域不自动修改
4. **及时记录**：每次操作后更新 log
5. **反链验证**：建立链接后**必须**用 `search get-backlinks --mode links` 验证真引用已建立
6. **用 `((块ID))` 建链接**：只有此格式建立真引用。`[[wikilink]]` 和 `siyuan://` 不产生 refs 记录
7. **`block replace` 是唯一可靠的链接替换方式**：`search find-replace` 和 `fs replace` 对块引用替换无效
8. **Lint 定期检查**：用 `search list-invalid-refs` 和 SQL 检查孤立页面
9. **引用段落块，不引用文档根块**：`((文档根块ID))` 嵌入整篇文档；`((标题块ID))` 只嵌入标题行。用 `document get-child-blocks` 获取标题块 ID

## 相关技能

- `siyuan-sisyphus`：CLI 总入口，了解命令结构、分页、JSON 输出
- `siyuan-sisyphus-browse-read`：浏览文档树、读取内容
- `siyuan-sisyphus-create-edit`：创建/编辑文档和块
- `siyuan-sisyphus-search-query`：全文搜索、SQL、反链、引用
- `siyuan-sisyphus-system-cli`：CLI 设置和配置
- `siyuan-markup-guide`：富文本 Markdown 语法
