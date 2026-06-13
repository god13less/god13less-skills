# god13less-skills

个人 Skills 仓库。将自定义 Skills 部署到 OpenCode / Claude / Codex。

## 安装

将 `skills/` 下的目录 symlink 或复制到对应平台的 skills 路径：

| 平台 | 安装路径 |
|------|---------|
| OpenCode | `~/.config/opencode/skills/` |
| Claude | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |

```bash
git clone https://github.com/god13less/god13less-skills.git
ln -s "$(pwd)/god13less-skills/skills/hello-world" ~/.config/opencode/skills/hello-world
```

## 更新

```bash
cd god13less-skills
git pull
```

## Skills 列表

| Skill | 描述 |
|-------|------|
| [hello-world](./skills/hello-world/) | 示例 Skill，验证安装成功 |

## 自定义

1. 在 `skills/` 下创建新目录
2. 添加 `SKILL.md`（格式见下方）
3. symlink 到目标平台路径

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
