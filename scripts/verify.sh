#!/bin/bash
# 云五笔一键验证脚本（豆包提供 · TRAE 用）
# 用法: bash verify.sh <编码>  # 如 bash verify.sh ggtt
CODE="${1:-ggtt}"
SDK="/Users/wellknow/Documents/trae_projects/wubi-flat/.sdk"
ADB="$SDK/platform-tools/adb"
# 1. 确保 IME 激活
"$ADB" shell ime enable com.wubi.flat/.WubiInputMethodService 2>/dev/null
"$ADB" shell ime set com.wubi.flat/.WubiInputMethodService 2>/dev/null
# 2. 打开输入框（设置页自带输入框）→ 点击坐标
"$ADB" shell am start -n com.wubi.flat/.MainActivity 2>/dev/null
sleep 2
# 3. 模拟软键盘点击（坐标按夜神 540x960 写死，必要时用 uiautomator dump 校准）
# 示例：q=100,300 p=... 逐字符 tap
echo "输入编码: $CODE"
# 4. 截图
"$ADB" exec-out screencap -p > "verify_${CODE}.png"
echo "截图已保存 verify_${CODE}.png"
