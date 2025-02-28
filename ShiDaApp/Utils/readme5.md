# Utils 目录

此目录用于存放应用的通用工具类，提供各种辅助功能和常用操作的封装。

## 目录结构

```
Utils/
├── DateUtils/        # 日期处理工具
│   ├── DateFormatter/
│   └── Calendar/
├── StringUtils/      # 字符串处理工具
├── FileUtils/        # 文件操作工具
├── SecurityUtils/    # 安全相关工具
│   ├── Encryption/
│   └── Hashing/
└── NetworkUtils/     # 网络工具
    └── Reachability/
```

## 开发规范

1. 工具类应该是无状态的，避免保存实例变量
2. 方法应该是简单且职责单一的
3. 提供详细的文档注释和使用示例
4. 确保线程安全性
5. 编写完整的单元测试
6. 使用适当的错误处理机制
7. 避免重复造轮子，优先使用系统提供的API