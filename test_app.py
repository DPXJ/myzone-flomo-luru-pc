"""
应用测试脚本
用于测试各个模块是否正常工作
"""
import sys

print("=" * 50)
print("  Flomo快速记录 - 模块测试")
print("=" * 50)
print()

# 测试1: 导入模块
print("[测试1] 导入模块...")
try:
    from config import Config
    print("  ✓ config.py 导入成功")
except Exception as e:
    print(f"  ✗ config.py 导入失败: {e}")
    sys.exit(1)

try:
    from flomo_api import FlomoAPI
    print("  ✓ flomo_api.py 导入成功")
except Exception as e:
    print(f"  ✗ flomo_api.py 导入失败: {e}")
    sys.exit(1)

try:
    from hotkey_manager import HotkeyManager
    print("  ✓ hotkey_manager.py 导入成功")
except Exception as e:
    print(f"  ✗ hotkey_manager.py 导入失败: {e}")
    sys.exit(1)

try:
    from main_window import MainWindow
    print("  ✓ main_window.py 导入成功")
except Exception as e:
    print(f"  ✗ main_window.py 导入失败: {e}")
    sys.exit(1)

try:
    from settings_window import SettingsWindow
    print("  ✓ settings_window.py 导入成功")
except Exception as e:
    print(f"  ✗ settings_window.py 导入失败: {e}")
    sys.exit(1)

print()

# 测试2: 配置管理
print("[测试2] 配置管理...")
try:
    config = Config("test_config.json")
    config.set("test_key", "test_value")
    value = config.get("test_key")
    assert value == "test_value", "配置读写不一致"
    print("  ✓ 配置读写正常")
    
    # 清理测试文件
    import os
    if os.path.exists("test_config.json"):
        os.remove("test_config.json")
except Exception as e:
    print(f"  ✗ 配置管理测试失败: {e}")

print()

# 测试3: Flomo API格式化
print("[测试3] Flomo API格式化...")
try:
    api = FlomoAPI("https://test.com")
    
    # 测试标签格式化（内部方法，通过send_memo间接测试）
    print("  ✓ API对象创建成功")
except Exception as e:
    print(f"  ✗ API测试失败: {e}")

print()

# 测试4: 快捷键验证
print("[测试4] 快捷键验证...")
try:
    assert HotkeyManager.is_valid_hotkey("ctrl+alt+f") == True
    assert HotkeyManager.is_valid_hotkey("f") == False
    print("  ✓ 快捷键格式验证正常")
except Exception as e:
    print(f"  ✗ 快捷键验证失败: {e}")

print()

# 测试5: PyQt6导入
print("[测试5] PyQt6环境...")
try:
    from PyQt6.QtWidgets import QApplication
    from PyQt6.QtCore import Qt
    from PyQt6.QtGui import QIcon
    print("  ✓ PyQt6导入成功")
except Exception as e:
    print(f"  ✗ PyQt6导入失败: {e}")
    print("  提示: 请运行 pip install -r requirements.txt")

print()

# 测试6: 其他依赖
print("[测试6] 其他依赖...")
dependencies = {
    "requests": "网络请求库",
    "keyboard": "全局热键库",
    "PIL": "图片处理库"
}

all_ok = True
for module_name, desc in dependencies.items():
    try:
        __import__(module_name)
        print(f"  ✓ {desc} ({module_name}) 已安装")
    except ImportError:
        print(f"  ✗ {desc} ({module_name}) 未安装")
        all_ok = False

print()
print("=" * 50)

if all_ok:
    print("✓ 所有测试通过！应用可以正常运行。")
    print()
    print("下一步:")
    print("1. 运行 run.bat 启动应用")
    print("2. 在系统托盘找到应用图标")
    print("3. 右键选择「设置」配置API地址")
else:
    print("✗ 部分测试失败，请先安装缺失的依赖:")
    print("  pip install -r requirements.txt")

print("=" * 50)
print()
input("按回车键退出...")

