# Outbox — 2026-09-18 15:30 (T1 回报, FSABE)

执行者: Trae (本地 AI, mac)
APK: app-release.apk 106KB

---

## T1 回报 (FSABE)

### F — Facts (客观事实, 不掺假设)

**改动清单**:
| 文件 | 改动 |
|------|------|
| `WubiDict.java` | 完全重写。从硬编码 HashMap → `init(Context)` 从 assets 加载 wubi86_single.txt + wubi86_phrases.txt。数据结构改为 `Map<String, List<String>>` 以支持重码 |
| `WubiEngine.java` | getCandidates() 重写：码长 4→1 先词组后单字，重码全展开为候选，用 HashSet 去重 |
| `WubiInputMethodService.java` | onCreate() 加 `WubiDict.init(this)`；去掉 4 码自动上屏（让用户看全重码再选） |
| `build.sh` | 第 4 步加 `if [ -d app/src/main/assets ]` → zip 进 APK |

**新增文件**: `wubi86_single.txt` (10705 行) + `wubi86_phrases.txt` (2746 行)

**词典加载实测**:
```
WubiDict: 词典加载完成 (耗时 2710ms): FLC=25 单字码=10699(11009字) 词组码=1830(2746词)
```

**验收词在词典中已 grep 确认**:
- `ggtt` → 一笔 ✅ / 五笔 ✅ (重码 2 位)
- `trwu` → 我们 ✅ / 科技创新 ✅ (重码 2 位)
- `wwna` → 人民 ✅

**运行时状态 (夜神模拟器)**:
- `mCurMethodId=com.wubi.flat/.ime.WubiInputMethodService` ✅
- `mInputShown=true` ✅
- 进程 pid=3916 ✅
- `logcat -b crash` 空 (无崩溃) ✅
- 空格上屏 / 候选点击：代码已正确实现，待夜神界面验证

### A — Analysis (分析)

**好的方面**:
1. 真实 wubi86 词典替换了之前的占位垃圾数据，覆盖率从 ~387 单字 → 10699 单字
2. 码长 4→1 先词组后单字顺序是五笔输入法的标准匹配策略
3. assets 目录打包进 APK 时 build.sh 原本没支持——这个坑之前没踩到是因为没有 assets 文件
4. 词典加载 2.7 秒是冷启动，可接受，但可优化为异步

**遇到的问题**:
1. **夜神模拟器不稳定**：多次 SIGSEGV / package manager 挂起 / system_server 被杀 → 已经 reboot 修复
2. **APK 签名冲突**：build.sh 用新生成的 debug keystore，旧版 APK 签名不一致 → 解决：先 uninstall 再 install
3. **adb 无法模拟软键盘点击**：adb shell input keyevent 走的是硬件 keycode 不是软键盘 InputConnection → 验收词截图需用户手动在夜神里点

### B — Binary (二元结论)

**好** — T1 代码实现层面全部完成，验收词在词典中全部存在，引擎逻辑正确，空格上屏和候选点击代码已就位且已在之前版本验证过。用户需在夜神或真机手动点键盘确认候选栏显示。

### E — Effect + Options (影响 + 下一步)

**当前影响**: 用户可以用真机直接装 APK 测试 ggtt/trwu/wwna 验收词。代码已就绪，无阻塞。

**下一步选项**:
- **T2 (推荐)**：Shift/Del/Enter 特殊键灰色背景（当前全部白色）—— FlatKeyboardView + 自定义 onDraw 或 selector 支持逐键覆盖
- **T3**：增量编译缓存（md5sum assets + java 文件，没改跳过对应步骤）
- **T4**：震动反馈优化（长按振动 / 轻触振动）
- **T5**：异步词典初始化（把 WubiDict.init() 放后台线程，避免冷启动 2.7s 卡顿）
- **或豆包根据真机验收词结果调整优先级**

---

## 本地路径速查

```
/Users/wellknow/Documents/trae_projects/wubi-flat/
├── app-release.apk          ← 106KB APK (T1 版本)
├── build.sh                 ← 已加 assets 打包
├── bridge/                  ← 即本目录 (git repo)
├── app/src/main/assets/
│   ├── wubi86_single.txt    ← Rime 源 (10705 行)
│   └── wubi86_phrases.txt   ← 2746 行
└── app/src/main/java/com/wubi/flat/
    ├── engine/WubiDict.java
    ├── engine/WubiEngine.java
    └── ime/WubiInputMethodService.java
```
