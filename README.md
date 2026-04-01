# 减肥记录应用

一个全平台的体重追踪和营养管理应用。

## 🌟 项目结构

```
weight-tracker/
├── uni-app/            # uni-app 跨平台应用 ⭐ 推荐 (一套代码，iOS/Android/微信小程序)
├── index.html          # Web 应用 (在线可访问)
├── android/            # Android 原生应用 (Kotlin + Jetpack Compose)
├── ios/                # iOS 原生应用 (Swift + SwiftUI)
└── flutter/            # Flutter 跨平台应用
```

---

## 🆕 uni-app 版本 (推荐)

**一套代码，同时生成 iOS、Android、微信小程序！**

### 功能特性

| 功能 | 描述 |
|------|------|
| ⚖️ **体重记录** | 每日体重记录、打卡系统、体重趋势统计 |
| 🏃 **运动记录** | 8种运动类型、自动计算消耗热量 |
| 🥗 **饮食记录** | 四餐记录、热量统计 |
| 👨‍⚕️ **营养师** | 一周食谱自动生成 |
| 📊 **统计** | 综合统计、体重进度、热量平衡 |

### 快速开始

```bash
cd uni-app
npm install
```

### 构建命令

```bash
# H5 网页版
npm run dev:h5      # 开发模式
npm run build:h5    # 生产构建

# 微信小程序
npm run dev:mp-weixin    # 开发模式
npm run build:mp-weixin  # 生产构建

# 其他平台
npm run dev:mp-alipay    # 支付宝小程序
npm run dev:mp-baidu     # 百度小程序
npm run dev:mp-toutiao   # 抖音小程序
```

### 微信小程序测试

1. 构建完成后，打开**微信开发者工具**
2. 导入项目目录: `uni-app/dist/build/mp-weixin`
3. 填写 AppID（测试可使用测试号）
4. 即可在模拟器中预览和调试

### iOS/Android 应用打包

uni-app 打包原生应用需要使用 HBuilderX:

1. 下载 [HBuilderX](https://www.dcloud.io/hbuilderx.html)
2. 导入 `uni-app` 目录
3. 点击 **发行** → **原生App-云打包**
4. 选择平台（iOS/Android）进行打包

---

## 在线访问

Web 版本: https://gangump82.github.io/weight-tracker/

## 技术栈

| 项目 | 框架 | 语言 | 支持平台 |
|------|------|------|---------|
| **uni-app** ⭐ | uni-app + Vue 3 | TypeScript | iOS, Android, 微信小程序, H5 |
| Flutter | Flutter 3.16+ | Dart | iOS, Android, Web |
| Web | HTML5 + TailwindCSS | JavaScript | Web |
| Android 原生 | Jetpack Compose | Kotlin | Android |
| iOS 原生 | SwiftUI | Swift | iOS |

## License

MIT
