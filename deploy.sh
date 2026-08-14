#!/bin/bash

cd /Users/chenhm/Documents/代码/Firefly

echo "📦 正在检查修改..."

# 检查是否有未提交的变更
if git diff --quiet && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✅ 没有新的文件变更。"
else
    # 有变更，执行添加和提交
    git add .
    echo "📝 以下文件将被提交："
    git status --short
    echo ""
    read -p "✏️  请输入提交信息（按 Enter 使用默认信息）: " msg
    if [ -z "$msg" ]; then
        msg="更新网站 $(date '+%Y-%m-%d %H:%M')"
    fi
    git commit -m "$msg"
fi

# 检查是否有未推送的提交
if git status | grep -q "Your branch is ahead of"; then
    echo "🚀 发现有未推送的提交，正在推送..."
    git push origin main
else
    echo "🚀 正在推送..."
    git push origin main
fi

if [ $? -eq 0 ]; then
    echo "✅ 部署完成！等待 1-2 分钟 Cloudflare Pages 自动构建。"
else
    echo "❌ 推送失败，请检查网络后重新运行脚本。"
fi