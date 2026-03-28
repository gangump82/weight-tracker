# 减肥记录应用

一个全平台的体重追踪和营养管理应用。

## 🌟 项目结构

```
weight-tracker/
├── index.html          # Web 应用 (在线可访问)
├── android/            # Android 原生应用 (Kotlin + Jetpack Compose)
├── ios/                # iOS 原生应用 (Swift + SwiftUI)
├── flutter/            # Flutter 跨平台应用 ⭐ 推荐
└── wardrobe-manager/   # 衣橱管家应用 🆕
```

---

## 🆕 衣橱管家 (Wardrobe Manager)

**智能衣物管理与穿搭助手**

### 核心功能

| 功能 | 描述 | 亮点 |
|------|------|------|
| 📸 **拍照录入** | 拍照即录入，AI 自动识别 | 10秒/件 |
| 🏠 **衣柜扫描** | 拍摄整个衣柜，AI 自动分析 | 5分钟/50件 |
| 🤖 **AI 搭配** | 语音描述需求，生成搭配方案 | 解放双手 |
| 📍 **位置管理** | 标记衣服位置，快速查找 | 不再翻箱倒柜 |

### 快速开始

```bash
cd wardrobe-manager
flutter pub get
flutter run
```

详细文档见 [wardrobe-manager/PRODUCT.md](wardrobe-manager/PRODUCT.md)

---

## 🦋 Flutter 减肥记录

**一套代码，同时生成 Android、iOS、Web 三端应用！**

### 快速开始

```bash
cd flutter
flutter pub get
flutter run -d chrome    # Web
flutter build apk        # Android
```

---

## 功能特性

### ⚖️ 体重记录
- 每日体重记录
- 打卡系统和连续天数统计
- 体重趋势图表

### 🏃 运动记录
- 8 种运动类型
- 自动计算消耗热量

### 🥗 饮食记录
- 四餐记录
- 热量统计

### 👨‍⚕️ 营养师功能
- 12 种人群类型
- 一周食谱自动生成

---

## 在线访问

Web 版本: https://gangump82.github.io/weight-tracker/

## 技术栈

| 项目 | 框架 | 语言 |
|------|------|------|
| **减肥记录 Flutter** | Flutter 3.16+ | Dart |
| **衣橱管家** | Flutter 3.16+ | Dart |
| Web | HTML5 + TailwindCSS | JavaScript |
| Android 原生 | Jetpack Compose | Kotlin |
| iOS 原生 | SwiftUI | Swift |

## License

MIT
