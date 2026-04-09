#!/bin/bash
# Push Tech Digest Report to Home Wiki
# 用法: ./push-report.sh /path/to/report.md

set -e

REPORT_FILE="$1"
WIKI_DIR="/home/administrator/.openclaw/workspace/home-wiki"

if [ -z "$REPORT_FILE" ]; then
    echo "❌ Error: Please provide report file path"
    echo "Usage: $0 /path/to/report.md"
    exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
    echo "❌ Error: Report file not found: $REPORT_FILE"
    exit 1
fi

DATE=$(basename "$REPORT_FILE" .md)
echo "📤 Pushing report: $DATE.md"

# 确保在 wiki 目录
cd "$WIKI_DIR"

# 创建 tech-digest 目录
mkdir -p tech-digest

# 复制报告
cp "$REPORT_FILE" "tech-digest/"

# 检查是否有变更
if [ -n "$(git status --porcelain)" ]; then
    echo "📝 Committing changes..."
    git add "tech-digest/$DATE.md"
    git commit -m "Add tech digest report: $DATE"
    
    echo "🚀 Pushing to home-wiki..."
    git push origin main
    echo "✅ Successfully pushed to home-wiki: tech-digest/$DATE.md"
else
    echo "✅ No changes to push"
fi
