# 减肥记录应用

一个全平台的体重追踪和营养管理应用。

## 🌟 项目结构

```
weight-tracker/
├── index.html          # Web 应用 (在线可访问)
├── android/            # Android 原生应用 (Kotlin + Jetpack Compose)
├── ios/                # iOS 原生应用 (Swift + SwiftUI)
└── flutter/            # Flutter 跨平台应用 ⭐ 推荐
```

## 🦋 Flutter 版本（推荐）

**一套代码，同时生成 Android、iOS、Web 三端应用！**

### 优势

| 特性 | Flutter | 原生 Android | 原生 iOS |
|------|---------|-------------|----------|
| 代码共享 | ✅ 100% | ❌ 单独代码 | ❌ 单独代码 |
| 维护成本 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 开发效率 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 性能 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

### 快速开始

```bash
cd flutter
flutter pub get
flutter run
```

### 构建

```bash
flutter build apk --release    # Android
flutter build ios --release    # iOS (需要 macOS)
flutter build web --release    # Web
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

| 平台 | 框架 | 语言 |
|------|------|------|
| **Flutter** ⭐ | Flutter 3.16+ | Dart |
| Web | HTML5 + TailwindCSS | JavaScript |
| Android 原生 | Jetpack Compose | Kotlin |
| iOS 原生 | SwiftUI | Swift |

## 本地开发

### Flutter（推荐）

```bash
cd flutter
flutter pub get
flutter run -d chrome    # Web
flutter run -d android   # Android 模拟器
flutter run -d ios       # iOS 模拟器
```

### Web

```bash
# 用浏览器打开 index.html 即可
open index.html
```

### Android 原生

```bash
cd android
./gradlew assembleDebug
# APK 在 app/build/outputs/apk/debug/
```

### iOS 原生

```bash
# 用 Xcode 打开
open ios/WeightTracker.xcworkspace
```

## 自动构建

推送到 main 分支后，GitHub Actions 会自动构建：
- Flutter Android APK
- Flutter iOS App
- Web 部署到 GitHub Pages

## License

MIT
