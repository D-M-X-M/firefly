#!/bin/bash
# 自动生成新动态模板，文件名基于当前日期时间，避免重复

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

DYNAMIC_DIR="src/content/dynamic"

# 获取当前日期时间（用于文件名和 Frontmatter）
DATE_FILENAME=$(date +%Y-%m-%d-%H%M%S)        # 例如 2026-08-18-123456
DATE_FRONTMATTER=$(date "+%Y-%m-%d %H:%M:%S")  # 例如 2026-08-18 12:34:56

mkdir -p "$DYNAMIC_DIR"

BASE_FILENAME="$DATE_FILENAME"
EXT=".md"
FILENAME="$BASE_FILENAME$EXT"

COUNTER=1
while [ -f "$DYNAMIC_DIR/$FILENAME" ]; do
    FILENAME="${BASE_FILENAME}-${COUNTER}${EXT}"
    COUNTER=$((COUNTER + 1))
done

# 生成动态的 Frontmatter 内容（动态通常只需要 published）
CONTENT="---
published: $DATE_FRONTMATTER
---

"

echo "$CONTENT" > "$DYNAMIC_DIR/$FILENAME"

echo "✅ 新动态已创建：$DYNAMIC_DIR/$FILENAME"
echo "📂 完整路径：$(pwd)/$DYNAMIC_DIR/$FILENAME"