# Features 目录

此目录用于存放应用的各个功能模块。每个功能模块应该是一个独立的目录，包含以下内容：

- Feature.swift - 包含该功能的 Reducer、Action 和 State
- Views/ - 该功能相关的视图组件
- Models/ - 该功能相关的数据模型
- Tests/ - 该功能的单元测试

## 目录结构示例

```
Features/
├── Authentication/
│   ├── AuthenticationFeature.swift
│   ├── Views/
│   │   ├── LoginView.swift
│   │   └── SignUpView.swift
│   └── Models/
│       └── User.swift
└── Home/
    ├── HomeFeature.swift
    └── Views/
        └── HomeView.swift
```

## 开发规范

1. 每个功能模块应该是独立的，尽量减少模块间的耦合
2. 使用 TCA 的架构模式，确保 State、Action 和 Reducer 的清晰分离
3. 视图组件应该是纯展示型的，业务逻辑应该放在 Reducer 中
4. 模块间的共享功能应该提取到 Core 目录中