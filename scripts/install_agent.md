# Mac 侧安装（TRAE 或用户执行，3 步）
1. 放脚本: 把 check_inbox.sh 放到 ~/cloudwubi-bridge/ 并授权
   mkdir -p ~/cloudwubi-bridge && cp check_inbox.sh ~/cloudwubi-bridge/ && chmod +x ~/cloudwubi-bridge/check_inbox.sh
2. 装 LaunchAgent:
   cp com.cloudwubi.inbox-check.plist ~/Library/LaunchAgents/
   launchctl unload ~/Library/LaunchAgents/com.cloudwubi.inbox-check.plist 2>/dev/null
   launchctl load ~/Library/LaunchAgents/com.cloudwubi.inbox-check.plist
3. 立即测一次:
   bash ~/cloudwubi-bridge/check_inbox.sh
   → 应弹出通知"📥 inbox 有新任务！"（首次 clone 后即触发）
注意事项: 通知需 macOS 允许"脚本编辑器/终端"发送通知; 首次 clone 后自动检测, 之后每 15 分钟一次。
