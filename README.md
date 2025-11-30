# Flomo快速记录

一个Windows桌面应用，通过全局快捷键快速记录笔记到Flomo。

## ✨ 功能特性

- 🚀 **全局快捷键** - 在任何应用中按快捷键即可快速记录
- 📝 **简洁界面** - 极简设计，专注内容输入
- 🏷️ **标签管理** - 支持自定义标签，快速分类
- 💾 **自动同步** - 实时同步到Flomo云端
- 🎯 **系统托盘** - 后台常驻，不占用任务栏
- ⚡ **轻量级** - 资源占用少，启动速度快

## 📦 安装依赖

```bash
pip install -r requirements.txt
```

## 🚀 快速开始

### 1. 获取Flomo API地址

1. 访问 [Flomo网页版](https://flomoapp.com/)
2. 进入「设置」→「API」
3. 复制你的专属API地址（格式：`https://flomoapp.com/iwh/xxxxx`）

### 2. 运行程序

```bash
python main.py
```

### 3. 配置应用

首次运行需要配置：

1. 右键点击系统托盘图标
2. 选择「⚙️ 设置」
3. 填入你的Flomo API地址
4. 点击「测试连接」验证
5. 自定义快捷键和默认标签（可选）
6. 保存设置

### 4. 开始使用

- 按快捷键（默认 `Ctrl+Alt+F`）唤起输入窗口
- 输入内容和标签
- 按 `Ctrl+Enter` 或点击「发送」按钮
- 笔记自动同步到Flomo ✅

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+Alt+F` | 唤起输入窗口（可自定义） |
| `Ctrl+Enter` | 发送笔记 |
| `ESC` | 关闭输入窗口 |

## 🎨 使用场景

- 💡 **灵感记录** - 随时捕捉突发灵感
- 📚 **学习笔记** - 快速记录学习要点
- 📋 **待办事项** - 记录临时任务
- 🎯 **项目想法** - 收集项目创意

## 📁 项目结构

```
flomo-quick-note/
├── main.py                 # 程序入口
├── config.py              # 配置管理
├── flomo_api.py           # Flomo API封装
├── hotkey_manager.py      # 全局热键管理
├── main_window.py         # 主输入窗口
├── settings_window.py     # 设置窗口
├── requirements.txt       # Python依赖
└── README.md             # 说明文档
```

## 🔧 配置文件

配置文件自动保存在 `config.json`：

```json
{
    "flomo_api_url": "你的Flomo API地址",
    "hotkey": "ctrl+alt+f",
    "default_tags": "灵感 想法",
    "auto_hide": true
}
```

## 📝 标签格式

- 多个标签用**空格**分隔
- 无需手动添加 `#` 号，程序会自动处理
- 示例：`灵感 想法 工作`

## ❓ 常见问题

### Q: 快捷键不生效？

A: 检查是否与其他程序冲突，尝试更换快捷键。需要以**管理员权限**运行程序。

### Q: 发送失败？

A: 
1. 检查API地址是否正确
2. 检查网络连接
3. 在设置中点击「测试连接」验证

### Q: 如何开机自启？

A: 将程序快捷方式放入Windows启动文件夹：
- 按 `Win+R` 输入 `shell:startup` 
- 将程序快捷方式复制到该文件夹

## 🛠️ 技术栈

- **Python 3.10+**
- **PyQt6** - GUI框架
- **keyboard** - 全局热键监听
- **requests** - HTTP请求

## 📜 许可证

MIT License

## 🙏 致谢

感谢 [Flomo](https://flomoapp.com/) 提供的优秀笔记服务。

---

**享受快速记录的乐趣！** 🎉

