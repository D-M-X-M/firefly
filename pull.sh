#!/bin/bash
# 拉取脚本 - 从 GitHub 同步最新更新到本地

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

echo "📥 正在从 GitHub 拉取最新更新..."

if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "⚠️  检测到本地有未提交的更改。"
    read -p "是否先提交这些更改？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        read -p "请输入提交信息: " msg
        git commit -m "$msg"
        echo "✅ 本地更改已提交。"
    else
        echo "⚠️  未提交的更改可能导致拉取失败或冲突。"
        read -p "是否继续拉取？(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "❌ 已取消拉取操作。"
            rmdir "$LOCK_DIR" 2>/dev/null
            exit 1
        fi
    fi
fi

git pull origin main

if [ $? -eq 0 ]; then
    echo "✅ 拉取成功！本地已同步最新更新。"
else
    echo "❌ 拉取失败，请检查网络或手动处理冲突。"
fi

rmdir "$LOCK_DIR" 2>/dev/null