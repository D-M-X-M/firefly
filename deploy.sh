#!/bin/bash

# 进入项目目录
cd /Users/chenhm/Documents/代码/Firefly || { echo "❌ 项目目录不存在！"; exit 1; }

echo "📦 正在检查修改..."

# 添加所有更改
git add .

# 显示将要提交的文件
echo "📝 以下文件将被提交："
git status --short

# 获取提交信息
echo ""
read -p "✏️  请输入提交信息（按 Enter 使用默认信息）: " msg
if [ -z "$msg" ]; then
  msg="更新网站 $(date '+%Y-%m-%d %H:%M')"
fi

# 提交
echo "📝 正在提交..."
if git commit -m "$msg"; then
  echo "✅ 提交成功"
else
  echo "❌ 提交失败，请检查是否有更改需要提交。"
  exit 1
fi

# 推送
echo "🚀 正在推送到 GitHub..."
if git push origin main; then
  echo "✅ 部署完成！等待 1-2 分钟 Cloudflare Pages 自动构建。"
else
  echo "❌ 推送失败！请检查网络或确认 GitHub 仓库地址正确。"
  echo "💡 提示：可以尝试执行以下命令重试："
  echo "   git push origin main"
  exit 1
fi