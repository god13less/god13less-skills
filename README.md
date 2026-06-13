# god13less-skills

个人 Skills 仓库。

## Skills 列表

| Skill | 分组 | 描述 |
|-------|------|------|
| [hello-world](./skills/hello-world/) | 示例 | 验证安装成功 |
| [siyuan-sisyphus](./skills/siyuan-sisyphus/) | siyuan | 思源笔记 CLI 顶层 Skill，安装/读取子 Skill |
| [siyuan-markup-guide](./skills/siyuan-markup-guide/) | siyuan | 思源 Markdown 标记指南 |
| [siyuan-sisyphus-browse-read](./skills/siyuan-sisyphus-browse-read/) | siyuan | 思源笔记浏览与阅读 |
| [siyuan-sisyphus-create-edit](./skills/siyuan-sisyphus-create-edit/) | siyuan | 思源笔记创建与编辑 |
| [siyuan-sisyphus-database](./skills/siyuan-sisyphus-database/) | siyuan | 思源属性视图/数据库操作 |
| [siyuan-sisyphus-file-export](./skills/siyuan-sisyphus-file-export/) | siyuan | 思源文件与资源导出 |
| [siyuan-sisyphus-search-query](./skills/siyuan-sisyphus-search-query/) | siyuan | 思源搜索与查询 |
| [siyuan-sisyphus-system-cli](./skills/siyuan-sisyphus-system-cli/) | siyuan | 思源系统配置与排障 |
| [siyuan-sisyphus-tag-flashcard](./skills/siyuan-sisyphus-tag-flashcard/) | siyuan | 思源标签与闪卡 |
| [n8n-code-javascript](./skills/n8n-code-javascript/) | n8n | n8n Code 节点 JavaScript 编程 |
| [n8n-code-python](./skills/n8n-code-python/) | n8n | n8n Code 节点 Python 编程 |
| [n8n-code-tool](./skills/n8n-code-tool/) | n8n | n8n Custom Code Tool (AI Agent 调用) |
| [n8n-expression-syntax](./skills/n8n-expression-syntax/) | n8n | n8n 表达式语法校验 |
| [n8n-mcp-tools-expert](./skills/n8n-mcp-tools-expert/) | n8n | n8n MCP 工具使用指南 |
| [n8n-node-configuration](./skills/n8n-node-configuration/) | n8n | n8n 节点配置指南 |
| [n8n-validation-expert](./skills/n8n-validation-expert/) | n8n | n8n 校验错误解读与修复 |
| [n8n-workflow-patterns](./skills/n8n-workflow-patterns/) | n8n | n8n 工作流架构模式 |

> siyuan-sisyphus 系列: [yangtaihong59/siyuan-plugins-mcp-sisyphus](https://github.com/yangtaihong59/siyuan-plugins-mcp-sisyphus)
> n8n 系列: [czlonkowski/n8n-skills](https://github.com/czlonkowski/n8n-skills)
> 由 GitHub Actions 每日自动同步。

## 文件结构

```
god13less-skills/
├── .github/workflows/
│   ├── sync-siyuan-skills.yml    # siyuan 自动同步
│   └── sync-n8n-skills.yml       # n8n 自动同步
├── skills/
│   ├── hello-world/
│   ├── siyuan-sisyphus/          # 思源系列 (9 skills)
│   │   └── ...                   # siyuan-* (8 more)
│   └── n8n-code-javascript/      # n8n 系列 (8 skills)
│       └── ...                   # n8n-* (7 more)
└── README.md
```
