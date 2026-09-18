#!/bin/bash
# 云五笔 inbox 检测助手（Mac 侧 · 豆包提供）
# 作用: 每 15 分钟拉取 bridge 仓库, inbox.md 有更新 → 弹 macOS 通知
BRIDGE_DIR="$HOME/cloudwubi-bridge"
HASH_FILE="$HOME/.cloudwubi_inbox_last_hash"

# 首次: clone 仓库
if [ ! -d "$BRIDGE_DIR/.git" ]; then
  git clone https://github.com/zsdili/cloudwubi-bridge.git "$BRIDGE_DIR" 2>/dev/null
  echo "首次 clone 完成"
fi
cd "$BRIDGE_DIR" || exit 0
git pull origin master --quiet 2>/dev/null

# 对比 inbox 哈希
NEW_HASH=$(sha256sum "$BRIDGE_DIR/inbox.md" | cut -c1-16)
OLD_HASH=""
[ -f "$HASH_FILE" ] && OLD_HASH=$(cat "$HASH_FILE")
if [ "$NEW_HASH" != "$OLD_HASH" ]; then
  osascript -e 'display notification "📥 inbox 有新任务！打开 Trae 说「看 inbox」" with title "云五笔协作桥梁" sound name "Glass"'
  echo "$NEW_HASH" > "$HASH_FILE"
  echo "$(date '+%H:%M') inbox 更新 → 已通知"
fi
