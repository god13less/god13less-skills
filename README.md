# god13less-skills

个人 Skills 仓库。

## Skills 列表

| Skill | 描述 |
|-------|------|
| [hello-world](./skills/hello-world/) | 示例 Skill，验证安装成功 |

## 自定义

1. 在 `skills/` 下创建新目录
2. 添加 `SKILL.md`（格式见下方）

### SKILL.md 格式

```markdown
---
name: my-skill
description: Skill 功能描述
---

# My Skill

## 使用场景

...

## 指令

...
```

### 命名规范

- `name`：1-64 字符，仅小写字母、数字和连字符 `a-z0-9-`，**必须与目录名一致**
- `description`：1-1024 字符
- 文件名必须是 `SKILL.md`（大写）

## 文件结构

```
god13less-skills/
├── skills/            # 所有 Skill 存放目录
│   └── hello-world/   # 示例 Skill
│       └── SKILL.md
└── README.md
```
