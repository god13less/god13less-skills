#!/bin/bash
set -e

# ============================================
# god13less-skills - Skills 卸载脚本
# ============================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PLATFORMS=(
    "opencode:$HOME/.config/opencode/skills"
    "claude:$HOME/.claude/skills"
    "codex:$HOME/.agents/skills"
)

echo "移除 god13less-skills..."

TOTAL=0
for entry in "${PLATFORMS[@]}"; do
    platform="${entry%%:*}"
    dest="${entry#*:}"

    local_count=0
    for skill_dir in "$SCRIPT_DIR/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")

        if [ -d "$dest/$skill_name" ] || [ -L "$dest/$skill_name" ]; then
            rm -rf "$dest/$skill_name"
            echo "  ✗ [$platform] $skill_name"
            local_count=$((local_count + 1))
        fi
    done
    TOTAL=$((TOTAL + local_count))
done

echo ""
echo "卸载完成，共移除 $TOTAL 个 Skill。"
