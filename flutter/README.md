# 减肥记录 - Flutter 版本

一套代码，同时支持 Android、iOS 和 Web 三端！

## 功能特性

- ⚖️ 体重记录与打卡系统
- 🏃 运动记录
- 🥗 饮食记录
- 👨‍⚕️ AI 营养师（一周食谱推荐）
- 📊 数据统计与分析

## 技术栈

- **Flutter** 3.16+
- **Dart** 3.0+
- **Provider** 状态管理
- **SharedPreferences** 本地存储
- **FL Chart** 图表展示

## 开始使用

### 安装 Flutter

```bash
# macOS/Linux
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor

# Windows
# 下载并解压 Flutter SDK
# 添加到 PATH 环境变量
```

### 运行项目

```bash
cd weight-tracker-flutter
flutter pub get
flutter run
```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# iOS (需要 macOS)
flutter build ios --release

# Web
flutter build web --release
```

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/
│   └── models.dart        # 数据模型
├── providers/
│   └── app_provider.dart  # 状态管理
└── screens/
    ├── home_screen.dart       # 主页面
    ├── weight_screen.dart     # 体重记录
    ├── exercise_screen.dart   # 运动记录
    ├── diet_screen.dart       # 饮食记录
    ├── nutritionist_screen.dart # AI营养师
    └── stats_screen.dart      # 统计页面
```

## 自动构建

推送到 main 分支后，GitHub Actions 会自动构建：
- Android APK
- iOS App（需 Xcode 签名才能安装）

## 平台对比

| 特性 | Flutter | 原生 Android | 原生 iOS |
|------|---------|-------------|----------|
| 代码共享 | ✅ 100% | ❌ | ❌ |
| 性能 | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 开发效率 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| UI 一致性 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## License

MIT
