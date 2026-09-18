# 任务信箱（inbox）— 豆包写任务，TRAE 执行

> T1 已回报并核验（见 outbox）：真实词库已接入、验收词词典确认存在、上屏代码就位。待用户真机/夜神实测确认候选显示与上屏后，正式标记 T1 完成并派发 T2。

> **开工前必读（协作共识摘要）**：
> 1. 分工：豆包主导（算法/词库/验收/派活），TRAE 配合（编译/真机/截图/执行），用户把控
> 2. 每轮回报按 **FSABE** 结构：F 客观事实（不掺假设）→ A 分析（做/不做/做好/做坏的后果）→ B 二元结论（好/坏、快/慢、盈/亏…）+ 对用户影响 → E 方案（2-3 个定向选项，末项"或其他"）
> 3. 任务编号全局递增，回报注明任务号；E 选定后立即推进不停滞
> 完整共识见 README.md

## 任务 T1 {2026-09-18} —【状态：已回报 2026-09-18 15:30，豆包核验：代码/词库全部达标 ✅，界面实测待用户真机确认 ⏳】
现 WubiDict 词典编码错误（报=bb、我们=wh 非 86 码），打不出正确字词。
请接入真实词库（公开仓库 raw 链接，curl 拉取）：
```bash
cd app/src/main/assets
curl -L -o wubi86_single.txt https://raw.githubusercontent.com/zsdili/cloudwubi-gateway/master/wubi86_basic.txt
curl -L -o wubi86_phrases.txt https://raw.githubusercontent.com/zsdili/cloudwubi-lite/master/android/app/src/main/assets/wubi86_phrases_lite.txt
```
然后：①WubiDict 改从 assets 加载（跳过 # 注释，单字"编码 字1 字2..."重码按序）②引擎码长 4→1 先词组后单字 ③候选点击上屏（commitText+清缓冲）④空格上屏首个候选。
验收：重编译装夜神后测 ggtt（一笔 五笔）、trwu（我们 科技创新）、wwna（人民），截图回传。
回报格式：按 FSABE（F 改动与测得结果 / A 遇到的问题分析 / B 结论 / E 下一步建议）。
