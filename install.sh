#!/bin/bash
set -e

# ============================================
# god13less-skills - Skills 安装脚本
# ============================================

DEST_DIR="${1:-$HOME/.config/opencode/skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔════════════════════════════════════════╗"
echo "║   god13less-skills 安装工具           ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "安装目标: $DEST_DIR"
echo ""

mkdir -p "$DEST_DIR"

SKILL_COUNT=0
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")

    # 移除旧链接
    rm -rf "$DEST_DIR/$skill_name"

    # 优先使用符号链接，失败则复制
    if ln -sf "$skill_dir" "$DEST_DIR/$skill_name" 2>/dev/null; then
        echo "  ✓ $skill_name (symlink)"
    else
        cp -r "$skill_dir" "$DEST_DIR/$skill_name"
        echo "  ✓ $skill_name (copied)"
    fi

    SKILL_COUNT=$((SKILL_COUNT + 1))
done

echo ""
echo "════════════════════════════════════════"
echo "  安装完成！共安装 $SKILL_COUNT 个 Skill"
echo "════════════════════════════════════════"
echo ""
echo "后续操作:"
echo "  1. 新 Skill 放入 skills/ 目录"
echo "  2. 运行 ./install.sh 更新"
echo "  3. 运行 ./uninstall.sh 移除全部"
echo ""
