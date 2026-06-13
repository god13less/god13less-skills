# god13less-skills

个人 Skills 仓库。

## Skills 列表

| Skill | 分组 | 描述 |
|-------|------|------|
| [hello-world](./skills/hello-world/) | 示例 | 验证安装成功 |
| [siyuan-sisyphus](./skills/siyuan-sisyphus/siyuan-sisyphus/) | siyuan | 思源笔记 CLI 顶层 Skill，安装/读取子 Skill |
| [siyuan-markup-guide](./skills/siyuan-sisyphus/siyuan-markup-guide/) | siyuan | 思源 Markdown 标记指南 |
| [siyuan-sisyphus-browse-read](./skills/siyuan-sisyphus/siyuan-sisyphus-browse-read/) | siyuan | 思源笔记浏览与阅读 |
| [siyuan-sisyphus-create-edit](./skills/siyuan-sisyphus/siyuan-sisyphus-create-edit/) | siyuan | 思源笔记创建与编辑 |
| [siyuan-sisyphus-database](./skills/siyuan-sisyphus/siyuan-sisyphus-database/) | siyuan | 思源属性视图/数据库操作 |
| [siyuan-sisyphus-file-export](./skills/siyuan-sisyphus/siyuan-sisyphus-file-export/) | siyuan | 思源文件与资源导出 |
| [siyuan-sisyphus-search-query](./skills/siyuan-sisyphus/siyuan-sisyphus-search-query/) | siyuan | 思源搜索与查询 |
| [siyuan-sisyphus-system-cli](./skills/siyuan-sisyphus/siyuan-sisyphus-system-cli/) | siyuan | 思源系统配置与排障 |
| [siyuan-sisyphus-tag-flashcard](./skills/siyuan-sisyphus/siyuan-sisyphus-tag-flashcard/) | siyuan | 思源标签与闪卡 |

> siyuan-sisyphus 系列 Skill 源: [yangtaihong59/siyuan-plugins-mcp-sisyphus](https://github.com/yangtaihong59/siyuan-plugins-mcp-sisyphus)
> 由 GitHub Actions 每日自动同步。

## 文件结构

```
god13less-skills/
├── .github/workflows/           # 自动同步 CI
│   └── sync-siyuan-skills.yml
├── skills/
│   ├── hello-world/             # 示例 Skill
│   │   └── SKILL.md
│   └── siyuan-sisyphus/         # 思源笔记系列 (自动同步)
│       ├── siyuan-sisyphus/
│       ├── siyuan-markup-guide/
│       ├── siyuan-sisyphus-browse-read/
│       ├── siyuan-sisyphus-create-edit/
│       ├── siyuan-sisyphus-database/
│       ├── siyuan-sisyphus-file-export/
│       ├── siyuan-sisyphus-search-query/
│       ├── siyuan-sisyphus-system-cli/
│       └── siyuan-sisyphus-tag-flashcard/
└── README.md
```
