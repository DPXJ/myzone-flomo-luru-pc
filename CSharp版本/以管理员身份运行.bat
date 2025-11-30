@echo off
:: 检查是否以管理员身份运行
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo 请求管理员权限...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     Flomo快速记录 - 管理员模式启动                   ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo ✅ 已获取管理员权限
echo.
echo 正在启动应用...
echo.

:: 查找exe文件
if exist "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe" (
    start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
    echo ✅ 应用已启动！
    echo.
    echo 💡 在系统托盘（右下角）找到应用图标
    echo 💡 按 Ctrl+Alt+F 唤起输入窗口
    timeout /t 3
) else (
    echo ❌ 未找到 FlomoQuickNote.exe
    echo.
    echo 请先编译项目:
    echo 1. 运行 build.bat
    echo 2. 等待编译完成
    echo 3. 重新运行本脚本
    pause
)

