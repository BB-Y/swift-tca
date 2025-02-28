# Resources 目录

此目录用于存放应用的各种资源文件，确保资源文件的统一管理和高效使用。

## 目录结构

```
Resources/
├── Images/        # 图片资源
│   ├── Icons/
│   └── Illustrations/
├── Fonts/         # 字体文件
├── Localization/  # 本地化文件
│   ├── en.lproj/
│   └── zh-Hans.lproj/
└── JSON/          # JSON数据文件
```

## 开发规范

1. 图片资源应该使用 Asset Catalog 进行管理
2. 所有资源文件应该有清晰的命名规范
3. 图片资源应该提供适当的分辨率版本（1x、2x、3x）
4. 本地化文件应该使用标准的.strings格式
5. 大型资源文件应该考虑按需加载
6. 注意资源文件的版权问题，确保拥有使用权