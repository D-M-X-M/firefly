#!/bin/bash

# 切换到项目根目录
cd /Users/chenhm/Documents/代码/Firefly

# 显示当前状态
echo "📦 正在检查修改..."

# 添加所有更改
git add .

# 显示要提交的文件（可让你确认，按Enter继续或Ctrl+C取消）
echo "📝 以下文件将被提交："
git status --short

echo ""
read -p "✏️  请输入提交信息（按 Enter 使用默认信息）: " msg

if [ -z "$msg" ]; then
  msg="更新网站 $(date '+%Y-%m-%d %H:%M')"
fi

# 提交
git commit -m "$msg"

# 推送
echo "🚀 正在推送到 GitHub..."
git push origin main

echo "✅ 部署完成！等待 1-2 分钟 Cloudflare Pages 自动构建。"