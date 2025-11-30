# Flomo快速记录 - C# WinForms 版本

**稳定、轻量、Windows原生**

## ✨ 特点

- ✅ **超级稳定** - Windows原生技术，不会卡死
- ✅ **轻量级** - 打包后仅10-20MB
- ✅ **秒开** - 启动速度快
- ✅ **完美支持** - 全局热键、系统托盘
- ✅ **无依赖** - .NET 6已内置于Windows 11

## 🚀 编译方法

### 方法1：使用Visual Studio 2022（推荐）

1. 安装 [Visual Studio 2022](https://visualstudio.microsoft.com/zh-hans/downloads/)
   - 安装时选择「.NET 桌面开发」工作负载

2. 打开项目
   ```
   双击 FlomoQuickNote.csproj
   ```

3. 编译运行
   ```
   按 F5 运行调试
   或
   按 Ctrl+Shift+B 仅编译
   ```

4. 发布单文件exe
   ```
   在解决方案资源管理器中右键项目
   → 发布
   → 选择「文件夹」
   → 配置：Release | win-x64
   → 发布
   ```

### 方法2：使用命令行（无需Visual Studio）

1. 安装 [.NET 6 SDK](https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0)

2. 打开命令行，进入项目目录
   ```bash
   cd "CSharp版本"
   ```

3. 编译运行
   ```bash
   dotnet run
   ```

4. 发布单文件exe
   ```bash
   dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
   ```

5. 生成的exe位于
   ```
   bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe
   ```

## 📦 使用方法

### 首次运行

1. 双击 `FlomoQuickNote.exe`

2. 在系统托盘（右下角）找到应用图标

3. 右键点击 → 设置

4. 填入你的Flomo API地址
   - 访问 https://flomoapp.com/
   - 登录 → 头像 → 设置 → API
   - 复制API地址

5. 点击「测试连接」验证

6. 保存设置

### 日常使用

1. 按 `Ctrl+Alt+F`（或你自定义的快捷键）

2. 输入内容和标签

3. 按 `Ctrl+Enter` 或点击「发送」

4. 笔记自动同步到Flomo ✅

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Alt+F` | 唤起输入窗口（可自定义） |
| `Ctrl+Enter` | 发送笔记 |
| `ESC` | 关闭窗口 |

## 🎯 系统要求

- **操作系统**: Windows 10 1809 或更高版本（包括Windows 11）
- **架构**: 64位
- **运行时**: .NET 6（Windows 11已内置）

## 📁 项目结构

```
CSharp版本/
├── FlomoQuickNote.csproj   # 项目文件
├── Program.cs              # 程序入口
├── FlomoApp.cs            # 主应用类
├── MainForm.cs            # 主输入窗口
├── SettingsForm.cs        # 设置窗口
├── ConfigManager.cs       # 配置管理
├── FlomoAPI.cs            # API封装
├── GlobalHotkey.cs        # 全局热键
└── README.md              # 本文件
```

## 🔧 技术栈

- **语言**: C# 10
- **框架**: .NET 6 + WinForms
- **依赖**: Newtonsoft.Json (仅配置文件序列化)

## ⚠️ 注意事项

1. **管理员权限**: 注册全局热键可能需要管理员权限
   - 右键exe → 以管理员身份运行

2. **防火墙**: 首次运行可能被Windows防火墙拦截
   - 选择「允许访问」

3. **热键冲突**: 如果快捷键不生效
   - 在设置中更换其他快捷键
   - 检查是否与其他软件冲突

## 🆚 对比Python版本

| 项目 | Python + PyQt6 | C# WinForms |
|------|---------------|-------------|
| 稳定性 | ⚠️ 可能卡死 | ✅ 非常稳定 |
| 打包大小 | ~50MB | ~15MB |
| 启动速度 | 较慢 | 秒开 |
| 渲染问题 | ❌ 有 | ✅ 无 |
| Windows兼容 | 一般 | ⭐⭐⭐⭐⭐ |

## 📝 配置文件

配置文件 `config.json` 会自动生成在exe同目录：

```json
{
  "FlomoApiUrl": "你的API地址",
  "Hotkey": "ctrl+alt+f",
  "DefaultTags": "灵感 想法",
  "LastTags": "",
  "AutoHide": true
}
```

## 🐛 故障排查

### Q: 双击exe没反应？
A: 
1. 检查是否已经在运行（看系统托盘）
2. 以管理员身份运行
3. 检查是否被杀毒软件拦截

### Q: 快捷键不生效？
A:
1. 以管理员身份运行
2. 在设置中更换其他快捷键
3. 检查是否与其他软件冲突

### Q: 发送失败？
A:
1. 检查API地址是否正确
2. 检查网络连接
3. 点击「测试连接」验证

## 💡 开发说明

### 添加新功能

1. 修改对应的`.cs`文件
2. 使用Visual Studio或命令行重新编译
3. 测试功能
4. 重新发布

### 调试技巧

- 使用Visual Studio的调试功能（F5）
- 查看输出窗口的错误信息
- 使用断点调试

## 📄 许可证

MIT License

## 🙏 致谢

- **Flomo** - 提供的笔记服务
- **Microsoft** - .NET平台

---

**享受稳定、快速的记录体验！** 🎉

