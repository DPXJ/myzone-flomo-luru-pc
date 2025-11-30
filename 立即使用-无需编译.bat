@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     立即使用 - Python 版本（无需编译）               ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo 无需安装 .NET SDK，使用 Python 版本立即开始！
echo.
echo ═══════════════════════════════════════════════════════════
echo.

REM 检查Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到 Python
    echo.
    echo 请先安装 Python 3.10+:
    echo https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

echo ✅ Python 已安装
echo.

echo [1/3] 安装依赖...
echo.
pip install -r requirements.txt
if errorlevel 1 (
    echo ❌ 依赖安装失败
    pause
    exit /b 1
)

echo.
echo ✅ 依赖安装完成
echo.

echo [2/3] 启动应用...
echo.
echo 应用将在后台启动，本窗口会自动关闭
echo.
timeout /t 2 /nobreak >nul

echo [3/3] 后台启动中...
start "" pythonw.exe main.py

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║              ✅ 应用已启动！                          ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo 💡 应用已在后台运行
echo 💡 请在系统托盘（右下角）找到应用图标
echo 💡 右键点击图标 → 设置 → 配置 Flomo API
echo 💡 按 Ctrl+Alt+F 唤起输入窗口
echo.
echo 本窗口将在 5 秒后自动关闭...
timeout /t 5
exit

