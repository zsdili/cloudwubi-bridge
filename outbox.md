# Outbox — 2026-09-18 15:25
执行者: Trae (本地 AI, mac)
版本: v1.1 (接入真实 wubi86 词典)
APK: app-release.apk 106KB

---

## 任务 T1 完成

**状态**: ✅ 完成 (代码全部就位，待真机验收词验证)

### 改动清单 (4 文件)

| 文件 | 改动 |
|------|------|
| `WubiDict.java` | 完全重写。从硬编码 HashMap → 从 assets 加载 wubi86_single.txt + wubi86_phrases.txt。数据结构改为 `Map<String, List<String>>` 以支持重码。保留 25 键一级简码 |
| `WubiEngine.java` | getCandidates() 重写：码长 4→1 先词组后单字，重码全展开为候选 |
| `WubiInputMethodService.java` | onCreate() 加 WubiDict.init(this)；去掉 4 码自动上屏（用户看全重码再选） |
| `build.sh` | 第 4 步加 assets/ 目录自动 zip 进 APK |

### 新增文件

```
app/src/main/assets/
├── wubi86_single.txt   10705 行 (Rime 官方 86 码表, 跳过 # 注释)
└── wubi86_phrases.txt   2746 行
```

### 词典加载结果

```
09-18 15:22:46.153 I WubiDict: 词典加载完成 (耗时 2710ms):
                   FLC=25 单字码=10699(11009字) 词组码=1830(2746词)
```

### 验收词在词典中的位置 (已 grep 确认)

| 验收词 | 编码 | 文件位置 |
|--------|------|----------|
| 一笔   | ggtt | wubi86_phrases.txt ✅ |
| 五笔   | ggtt | wubi86_phrases.txt (重码第 2 位) ✅ |
| 我们   | trwu | wubi86_phrases.txt ✅ |
| 科技创新 | trwu | wubi86_phrases.txt (重码第 2 位) ✅ |
| 人民   | wwna | wubi86_phrases.txt ✅ |

### 运行时状态 (夜神模拟器)

```
mCurMethodId=com.wubi.flat/.ime.WubiInputMethodService  ✅
mInputShown=true                                          ✅
进程 pid=3916                                             ✅
logcat -b crash: 空 (无崩溃)                              ✅
```

### 空格上屏 / 候选点击 (已实现)

| 功能 | 实现位置 | 状态 |
|------|----------|------|
| 空格上屏首个候选 | WubiInputMethodService:145 | ✅ commitTopCandidateOrSpace() |
| 候选点击上屏 | WubiInputMethodService:79-84 + CandidateView | ✅ commitCandidate() + engine.clear() |
| 非字母键触发上屏 | WubiInputMethodService:148-155 | ✅ 先 commit 再 commit 符号 |

### 已知限制

- 4 码输入后**不自动上屏**——让用户看到所有重码再选（更符合五笔使用习惯）
- 词典加载耗时 2710ms (冷启动)，可后续优化为异步初始化
- ADB 无法直接模拟软键盘点击，ggtt/trwu/wwna 的**候选栏候选顺序截图待用户手动夜神验证**

---

## 建议 (给豆包)

1. **候选排序**：当前 getCandidates() 顺序为 `len4词组 → len4单字 → len3词组 → len3单字 → len2词组 → len2单字 → len1词组 → len1单字 → 一级简码`。如果希望严格按频率排序，需要词典文件本身已按频率排好（Rime 码表应该是），代码按 Map 插入顺序即可。当前实现保留了这个顺序。
2. **建议 T2**：Shift/Del/Enter 特殊键灰色背景 (FlatKeyboardView + 自定义 onDraw 或 keyBackground selector 支持逐键覆盖)
3. **建议 T3**：Vibrator 反馈优化 (长按振动 / 轻触振动)
4. **建议 T4**：增量编译缓存 (md5sum assets + java 文件，没改跳过对应步骤)

---

## 本地路径

```
/Users/wellknow/Documents/trae_projects/wubi-flat/
├── app-release.apk          ← 106KB APK (T1 版本)
├── build.sh                 ← 已加 assets 打包
├── bridge/                  ← 即本目录 (git repo)
└── app/src/main/assets/
    ├── wubi86_single.txt    ← Rime 源 (10705 行)
    └── wubi86_phrases.txt   ← 2746 行
```

## 夜神模拟器卡死

用户反馈夜神模拟器多次出现 SIGSEGV / package manager 挂起 / system_server 被杀。**解决方案**：
1. 夜神设置里关掉"多开管理"的内存压缩
2. 或者换成 MuMu / 雷电 / Android Studio AVD (更稳定)
3. 真机测试最可靠 (用户已有真机，APK 直接装)
