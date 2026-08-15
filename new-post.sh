#!/bin/bash
# 自动生成新文章模板，文件名基于当前日期，避免重复

# 获取脚本所在目录（项目根目录）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# 设置文章目录
POSTS_DIR="src/content/posts"

# 获取当前日期 YYYYMMDD（用于文件名）和 YYYY-MM-DD（用于 Frontmatter）
DATE_FILENAME=$(date +%Y%m%d)
DATE_FRONTMATTER=$(date +%Y-%m-%d)

# 确保目录存在
mkdir -p "$POSTS_DIR"

# 生成基础文件名
BASE_FILENAME="$DATE_FILENAME"
EXT=".md"
FILENAME="$BASE_FILENAME$EXT"

# 若文件已存在，则添加后缀 -1, -2, ...
COUNTER=1
while [ -f "$POSTS_DIR/$FILENAME" ]; do
    FILENAME="${BASE_FILENAME}-${COUNTER}${EXT}"
    COUNTER=$((COUNTER + 1))
done

# 生成 Frontmatter 内容
CONTENT="---
title: \"\"              # 文章标题（必填）
published: $DATE_FRONTMATTER  # 发布日期（必填，格式 YYYY-MM-DD）
updated: $DATE_FRONTMATTER    # 更新日期（可选，不填则默认同 published）
description: \"\"        # 简短描述（可选，用于 SEO 和列表展示）
image: \"\"              # 封面图路径（可选，支持本地或网络图片）
tags: []               # 标签列表（可选，如 [前端, 生活]）
category: \"\"           # 分类名称（可选）
draft: false           # 是否为草稿（可选，true 则线上隐藏）
pinned: false          # 是否置顶（可选，true 则文章置顶）
comment: true          # 是否启用评论（可选，默认 true）
slug: \"\"               # 自定义 URL（可选，默认使用文件名）
password: \"\"           # 访问密码（可选，设置后需密码查看）
passwordHint: \"\"       # 密码提示（可选，配合 password 使用）
sourceLink: \"\"         # 来源链接或参考（可选）
---

"

# 写入文件
echo "$CONTENT" > "$POSTS_DIR/$FILENAME"

echo "✅ 新文章已创建：$POSTS_DIR/$FILENAME"
echo "📂 完整路径：$(pwd)/$POSTS_DIR/$FILENAME"