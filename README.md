# 减肥记录应用

一个全平台的体重追踪和营养管理应用。

## 项目结构

```
├── index.html              # Web 应用入口
├── android/                # Android 应用 (Kotlin + Jetpack Compose)
└── ios/                    # iOS 应用 (Swift + SwiftUI)
```

## 功能特性

### ⚖️ 体重记录
- 每日体重记录
- 打卡系统和连续天数统计
- 体重趋势图表
- 减重进度追踪

### 🏃 运动记录
- 8 种运动类型（跑步、游泳、骑行等）
- 自动计算消耗热量
- 本周/本月运动统计

### 🥗 饮食记录
- 四餐记录（早餐、午餐、晚餐、加餐）
- 热量统计
- 本周饮食分析

### 👨‍⚕️ 营养师功能
- 12 种人群类型（婴儿、孕妇、健身人士、中老年人等）
- 特殊需求支持（糖尿病、高血压、痛风等）
- 一周食谱自动生成
- 营养分析和建议

### 📊 统计分析
- 综合数据统计
- 热量平衡分析
- 目标进度展示

## 在线访问

Web 版本: https://gangump82.github.io/weight-tracker/

## 技术栈

| 平台 | 技术栈 |
|------|--------|
| Web | HTML5 + TailwindCSS + Chart.js |
| Android | Kotlin + Jetpack Compose + Room |
| iOS | Swift + SwiftUI |

## 本地开发

### Web
```bash
# 用浏览器打开 index.html 即可
open index.html
```

### Android
```bash
cd android
./gradlew assembleDebug
# APK 位于 app/build/outputs/apk/debug/
```

### iOS
```bash
# 用 Xcode 打开
open ios/WeightTracker.xcworkspace
```

## License

MIT
