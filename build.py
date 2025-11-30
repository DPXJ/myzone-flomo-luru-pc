"""
打包脚本 - 将应用打包成Windows可执行文件
使用PyInstaller进行打包
"""
import os
import sys
import shutil

print("=" * 50)
print("  Flomo快速记录 - 打包脚本")
print("=" * 50)
print()

# 检查PyInstaller是否安装
try:
    import PyInstaller
    print("✓ PyInstaller已安装")
except ImportError:
    print("✗ PyInstaller未安装，正在安装...")
    os.system("pip install pyinstaller")
    print("✓ PyInstaller安装完成")

print()
print("开始打包...")
print()

# 打包命令
cmd = [
    "pyinstaller",
    "--name=FlomoQuickNote",  # 程序名称
    "--onefile",  # 打包成单个文件
    "--windowed",  # 无控制台窗口
    "--icon=resources/icon.ico" if os.path.exists("resources/icon.ico") else "",  # 图标
    "--add-data=config.json;." if os.path.exists("config.json") else "",  # 添加配置文件
    "--hidden-import=PyQt6",  # 隐藏导入
    "--hidden-import=keyboard",
    "--hidden-import=requests",
    "--hidden-import=PIL",
    "main.py"
]

# 过滤空参数
cmd = [arg for arg in cmd if arg]

# 执行打包
cmd_str = " ".join(cmd)
print(f"执行命令: {cmd_str}")
print()

result = os.system(cmd_str)

if result == 0:
    print()
    print("=" * 50)
    print("✓ 打包成功！")
    print()
    print("可执行文件位置: dist/FlomoQuickNote.exe")
    print()
    print("提示:")
    print("1. 首次运行需要配置Flomo API地址")
    print("2. 建议以管理员权限运行以注册全局热键")
    print("3. 可以将exe文件移动到任意位置使用")
    print("=" * 50)
else:
    print()
    print("=" * 50)
    print("✗ 打包失败，请检查错误信息")
    print("=" * 50)

print()
input("按回车键退出...")

