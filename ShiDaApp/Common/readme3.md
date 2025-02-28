# Core 目录

此目录用于存放应用的核心业务逻辑和通用组件。这些组件应该是与具体业务无关的，可以被多个功能模块复用。

## 目录结构

```
Core/
├── Components/     # 通用UI组件
│   ├── Buttons/
│   ├── Cards/
│   └── Lists/
├── Extensions/     # Swift扩展
├── Protocols/      # 通用协议
└── Utils/          # 工具类
    ├── Formatters/
    └── Validators/
```

## 开发规范

1. 组件应该是高度可复用的，避免包含特定业务逻辑
2. 每个组件都应该有完整的文档和使用示例
3. 保持组件的简单性和单一职责
4. 编写单元测试确保组件的可靠性
5. 使用 Swift 的访问控制确保 API 的清晰性