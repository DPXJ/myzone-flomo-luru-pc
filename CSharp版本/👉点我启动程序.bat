@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          🚀 启动 Flomo 快速记录                      ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if not exist "%EXE_PATH%" (
    echo ❌ 找不到程序文件！
    echo.
    echo 文件位置: %EXE_PATH%
    echo.
    echo 请先运行 "重新编译.bat" 生成程序
    echo.
    pause
    exit /b 1
)

echo ✅ 找到程序文件
echo.
echo 📍 位置: %EXE_PATH%
echo.
echo 🚀 正在启动程序...
echo.

REM 检查是否已经在运行
tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I /N "FlomoQuickNote.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ⚠️  程序已在运行！
    echo.
    echo 请在系统托盘（右下角）找到图标
    echo 点击右下角的 "^" 符号展开隐藏图标
    echo.
    pause
    exit /b 0
)

REM 启动程序
start "" "%EXE_PATH%"

timeout /t 2 >nul

REM 再次检查是否启动成功
tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I /N "FlomoQuickNote.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo.
    echo ╔═══════════════════════════════════════════════════════╗
    echo ║                                                       ║
    echo ║              ✅ 程序启动成功！                        ║
    echo ║                                                       ║
    echo ╚═══════════════════════════════════════════════════════╝
    echo.
    echo 📍 如何找到应用：
    echo.
    echo    1. 看屏幕 **右下角** （时间旁边）
    echo    2. 点击 **"^"** 或 **"∧"** 符号
    echo    3. 在弹出的图标中找 "Flomo快速记录"
    echo    4. **右键点击** 图标 → 选择 "设置"
    echo    5. 配置 Flomo API 后就能使用了！
    echo.
    echo ⌨️  或者直接按快捷键: Ctrl+Alt+F
    echo.
) else (
    echo.
    echo ❌ 启动失败！
    echo.
    echo 可能原因:
    echo    1. 被安全软件拦截
    echo    2. 缺少必要的系统组件
    echo    3. 需要管理员权限
    echo.
    echo 💡 解决方法:
    echo    请运行 "以管理员身份运行.bat"
    echo.
)

pause

