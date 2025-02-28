# ShiDaApp

一个基于 SwiftUI 和 TCA (The Composable Architecture) 架构的 iOS 应用。

## 项目结构

```
ShiDaApp/
├── Core/           # 核心组件和通用功能
│   ├── Components/  # 通用UI组件
│   ├── Extensions/  # Swift扩展
│   ├── Protocols/   # 通用协议
│   └── Utils/       # 工具类
├── Features/       # 功能模块
│   ├── Authentication/  # 认证模块
│   └── Home/           # 首页模块
├── Services/       # 服务层
│   ├── API/        # API服务
│   ├── Database/   # 数据库服务
│   └── Cache/      # 缓存服务
├── Utils/          # 通用工具
│   ├── DateUtils/   # 日期处理
│   ├── StringUtils/ # 字符串处理
│   ├── FileUtils/   # 文件操作
│   ├── SecurityUtils/ # 安全相关
│   └── NetworkUtils/ # 网络工具
└── Resources/      # 资源文件
```

## 技术栈

- SwiftUI：用于构建用户界面
- TCA (The Composable Architecture)：状态管理和业务逻辑

## 目录说明

### Core
- 存放应用的核心业务逻辑和通用组件
- 包含可复用的UI组件、Swift扩展和通用协议
- 组件设计遵循高复用性和单一职责原则

### Features
- 按功能模块组织的业务代码
- 每个功能模块包含：
  - Feature.swift：包含 Reducer、Action 和 State
  - Views：相关视图组件
  - Models：数据模型
  - Tests：单元测试

### Services
- API：处理网络请求和数据模型
- Database：数据持久化服务
- Cache：缓存管理

### Utils
- 提供各类通用工具类
- 包含日期、字符串、文件、安全和网络等工具

## 开发规范

1. 架构规范
   - 使用 TCA 架构模式
   - 确保 State、Action 和 Reducer 的清晰分离
   - 保持模块间的低耦合度

2. 代码规范
   - 组件应保持简单性和单一职责
   - 编写完整的文档和使用示例
   - 确保代码的可测试性
   - 编写单元测试

3. 工具类规范
   - 工具类应该是无状态的
   - 方法应该简单且职责单一
   - 确保线程安全性
   - 优先使用系统提供的 API

4. 模块开发规范
   - 模块间共享功能应提取到 Core 目录
   - 视图组件应该是纯展示型的
   - 业务逻辑应该放在 Reducer 中