#!/bin/bash
set -e

# ============================================
# god13less-skills - Skills 安装脚本
# ============================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 支持的平台及对应 skills 目录
PLATFORMS=(
    "opencode:$HOME/.config/opencode/skills"
    "claude:$HOME/.claude/skills"
    "codex:$HOME/.agents/skills"
)

echo "╔════════════════════════════════════════╗"
echo "║   god13less-skills 安装工具           ║"
echo "╚════════════════════════════════════════╝"
echo ""

install_to() {
    local platform=$1
    local dest=$2

    mkdir -p "$dest"

    local count=0
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        local skill_name=$(basename "$skill_dir")

        rm -rf "$dest/$skill_name"

        if ln -sf "$skill_dir" "$dest/$skill_name" 2>/dev/null; then
            echo "  ✓ $skill_name (symlink)"
        else
            cp -r "$skill_dir" "$dest/$skill_name"
            echo "  ✓ $skill_name (copied)"
        fi

        count=$((count + 1))
    done

    echo "  → 已安装到 $dest ($count 个 Skill)"
}

for entry in "${PLATFORMS[@]}"; do
    platform="${entry%%:*}"
    dest="${entry#*:}"

    echo "[$platform]"
    install_to "$platform" "$dest"
    echo ""
done

echo "════════════════════════════════════════"
echo "  安装完成"
echo "════════════════════════════════════════"
echo ""
echo "后续操作:"
echo "  1. 新 Skill 放入 skills/ 目录"
echo "  2. 运行 ./install.sh 更新"
echo "  3. 运行 ./uninstall.sh 移除全部"
echo ""
