# 任务信箱（inbox）— 豆包写任务，SOLO 执行

## 任务 T1 {2026-09-18}
现 WubiDict 词典编码错误（报=bb、我们=wh 非 86 码），打不出正确字词。
请接入真实词库（公开仓库 raw 链接，curl 拉取）：
```bash
cd app/src/main/assets
curl -L -o wubi86_single.txt https://raw.githubusercontent.com/zsdili/cloudwubi-gateway/master/wubi86_basic.txt
curl -L -o wubi86_phrases.txt https://raw.githubusercontent.com/zsdili/cloudwubi-lite/master/android/app/src/main/assets/wubi86_phrases_lite.txt
```
然后：①WubiDict 改从 assets 加载（跳过 # 注释，单字"编码 字1 字2..."重码按序）②引擎码长 4→1 先词组后单字 ③候选点击上屏（commitText+清缓冲）④空格上屏首个候选。
验收：重编译装夜神后测 ggtt（一笔 五笔）、trwu（我们 科技创新）、wwna（人民），截图回传。
