@echo off
chcp 65001 >nul
cls
cd /d "%~dp0"

echo ═══════════════════════════════════════════════════════════
echo               开始编译 Flomo 快速笔记
echo ═══════════════════════════════════════════════════════════
echo.

REM 查找 dotnet.exe
set "DOTNET_EXE="

if exist "C:\Program Files\dotnet\dotnet.exe" (
    set "DOTNET_EXE=C:\Program Files\dotnet\dotnet.exe"
    goto :compile
)

if exist "%ProgramFiles%\dotnet\dotnet.exe" (
    set "DOTNET_EXE=%ProgramFiles%\dotnet\dotnet.exe"
    goto :compile
)

if exist "C:\Program Files (x86)\dotnet\dotnet.exe" (
    set "DOTNET_EXE=C:\Program Files (x86)\dotnet\dotnet.exe"
    goto :compile
)

echo ❌ 未找到 .NET SDK
echo.
echo 请先安装 .NET 6 SDK
pause
exit /b 1

:compile
echo ✅ 找到 .NET SDK: %DOTNET_EXE%
echo.
echo [1/2] 清理旧文件...
if exist bin rd /s /q bin >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1
echo.

echo [2/2] 开始编译 (需要1-2分钟)...
echo.

"%DOTNET_EXE%" publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true

if errorlevel 1 (
    echo.
    echo ❌ 编译失败！
    echo.
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════════
echo                 🎉 编译成功！
echo ═══════════════════════════════════════════════════════════
echo.

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if exist "%EXE_PATH%" (
    echo ✅ 程序位置: %EXE_PATH%
    echo.
    echo 🚀 下一步:
    echo    1. 运行: 以管理员身份运行.bat
    echo    2. 在托盘图标右键 → 设置
    echo    3. 配置 Flomo API
    echo    4. 按 Ctrl+Alt+F 开始使用
    echo.
) else (
    echo ❌ 未找到生成的exe文件
    echo.
)

pause

