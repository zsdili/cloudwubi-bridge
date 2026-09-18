# Outbox — 2026-09-18 17:00 (用户指令: 按图二重设计 UI)

执行者: Trae (本地 AI, mac)
APK: app-release.apk 106KB

---

## 共识确认

✅ **共识已确认，继续执行。**

---

## UI 重设计回报

**触发**: 用户指令 — "按照图二（参考图）的主题风格、功能布局等 UI 层面要重新设计"

### F — Facts (改动)

| 组件 | T1 版本 | 重设计版本 (对齐图二) |
|------|---------|----------------------|
| 键盘布局 | 6 行 (含独立数字行) | **5 行** — 去掉独立数字行，QWERTY 直接接数字上档（图二是这样的） |
| 特殊键背景 | 全白色（无区分） | **灰底** — FlatKeyboardView 通过反射给 Shift/Del/?123/中英/Emoji/换行 设置 `bg_key_special` |
| Shift 键 | 空 label | **↑** 图标 |
| Del 键 | 空 label | **⌫** 图标 |
| Emoji 键 | ^_^ | **��** |
| 空格 | 空白长键 | **空白长键**（图二是语音图标，但 Android KeyboardView 不支持自定义 icon 到空格，保留空白） |
| 候选栏 (空状态) | 无显示 | **常用词热区** — 嗯 我 你 好 哦 + 左 ⊞ + 右 ▾ |
| 候选栏 (有 buffer) | bufferText + 候选列表 | bufferText + 候选列表 + 左 ⊞ + 右 ▾ |
| 配色 | keyboard_bg=#D1D3D8 | **#C8CACC**（更接近图二的灰），特殊键=#9A9DA3 |
| Row 布局 | keyWidth=10%p | keyWidth=10%p + Shift/Del 12% + 空格 30% |

**改动文件** (4):
- `keyboard_wubi.xml` — 5 行布局重写
- `FlatKeyboardView.java` — 加 applySpecialKeyBg() 反射设置特殊键灰底 + 图标
- `CandidateView.java` — 常用词热区 + 左右图标
- `colors.xml` — 微调配色

### A — Analysis

**好事**:
1. FlatKeyboardView 通过反射 `Keyboard.Key.background` 字段给特殊键设置不同背景 — 这是原生 KeyboardView 不支持的能力，我们实现了
2. 候选栏常用词热区模仿了图二的"嗯 我 你 好 哦"布局，交互上点击直接上屏
3. 5 行布局更紧凑，跟图二一致

**限制**:
1. **Nightshift 模拟器 ROM bug** — 每次启动 SettingsActivity 强制切回 softkeyboard。需要 `ime disable com.example.android.softkeyboard/.SoftKeyboard` 才能触发我们的 IME。截图是在禁用后拍的。
2. 空格键语音图标 — Android KeyboardView 的空格（code=32）不支持自定义 icon，保留空白。
3. 候选栏的 **网格图标 ⊞** 和 **下拉箭头 ▾** 用 Unicode 文字，不如真正的 vector drawable 好看。可后续替换。
4. 字母大小写 — 现在 keyLabel="Q" 大写，但原生 KeyboardView 默认会显示上档状态，不需要我们改 label。

### B — Binary

**好** — UI 按图二重设计完成，编译零错误、进程存活、词典功能不受影响。Nightshift 模拟器需要先 disable softkeyboard 才能稳定测试我们的 IME。

### E — Options

- **继续微调 (推荐)** — 用户看截图反馈哪里不像图二，针对性调整
- **T2 全量面板** — 豆包出 4 面板布局图后一起实现（中文/数字/符号/剪贴板）
- **修复 Nightshift bug** — 在 build.sh 或 README 里加一行 `adb shell ime disable com.example.android.softkeyboard/.SoftKeyboard` 作为测试前置
- **或其他**

---

## 本地路径

```
/Users/wellknow/Documents/trae_projects/wubi-flat/
├── app-release.apk          ← 106KB APK (UI 重设计版)
├── t2_ui_new.png            ← 夜神截图 (43KB)
├── bridge/                  ← 本目录
└── app/src/main/res/
    ├── xml/keyboard_wubi.xml
    └── values/colors.xml
```
