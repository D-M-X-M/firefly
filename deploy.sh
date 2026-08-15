#!/bin/bash
# 部署脚本 - 推送到 GitHub，触发 Cloudflare Pages 自动构建

cd /Users/chenhm/Documents/代码/Firefly || exit

LOCK_DIR="/tmp/firefly_git.lock"
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    echo "❌ 另一个 Git 脚本正在运行，请稍后重试。"
    exit 1
fi

cleanup() {
    echo -e "\n⚠️ 操作被中断，正在清理锁文件..."
    rmdir "$LOCK_DIR" 2>/dev/null
    exit 1
}
trap cleanup SIGINT SIGTERM

echo "🌐 检查 GitHub 网络连通性..."
if ! ping -c 2 github.com &>/dev/null; then
    echo "❌ 无法连接到 GitHub，请检查网络后重试。"
    rmdir "$LOCK_DIR" 2>/dev/null
    exit 1
fi

echo "📦 正在检查修改..."
if git diff --quiet && git diff --staged --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✅ 没有新的文件变更。"
else
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

if git status | grep -q "Your branch is ahead of"; then
    echo "🚀 发现有未推送的提交，正在推送..."
else
    echo "🚀 正在推送..."
fi

git push origin main

if [ $? -eq 0 ]; then
    echo "✅ 部署完成！等待 1-2 分钟 Cloudflare Pages 自动构建。"
else
    echo "❌ 推送失败，请检查网络后重试。"
fi

rmdir "$LOCK_DIR" 2>/dev/null