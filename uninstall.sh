#!/bin/bash
set -e

# ============================================
# god13less-skills - Skills 卸载脚本
# ============================================

DEST_DIR="${1:-$HOME/.config/opencode/skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "移除 god13less-skills..."

COUNT=0
for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$skill_dir" ] || continue
    skill_name=$(basename "$skill_dir")

    if [ -d "$DEST_DIR/$skill_name" ] || [ -L "$DEST_DIR/$skill_name" ]; then
        rm -rf "$DEST_DIR/$skill_name"
        echo "  ✗ $skill_name 已移除"
        COUNT=$((COUNT + 1))
    fi
done

echo ""
echo "卸载完成，共移除 $COUNT 个 Skill。"
