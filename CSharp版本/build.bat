@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     Flomo快速记录 - C# 版本编译脚本                  ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.
echo.

REM 检查 .NET SDK
echo [1/4] 检查 .NET SDK...
dotnet --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ❌ 未检测到 .NET SDK
    echo.
    echo 请先安装 .NET 6 SDK:
    echo https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    echo.
    pause
    exit /b 1
)

echo ✅ .NET SDK 已安装
for /f "tokens=*" %%i in ('dotnet --version') do set DOTNET_VERSION=%%i
echo    版本: %DOTNET_VERSION%
echo.

REM 清理旧文件
echo [2/4] 清理旧文件...
if exist bin\Release rd /s /q bin\Release
if exist obj rd /s /q obj
echo ✅ 清理完成
echo.

REM 还原依赖
echo [3/4] 还原依赖包...
dotnet restore
if errorlevel 1 (
    echo.
    echo ❌ 依赖包还原失败
    pause
    exit /b 1
)
echo ✅ 依赖包还原完成
echo.

REM 编译发布
echo [4/4] 编译发布 (这可能需要1-2分钟)...
echo.
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
if errorlevel 1 (
    echo.
    echo ❌ 编译失败
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║              ✅ 编译成功！                            ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.
echo 📦 生成的exe位置:
echo    bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe
echo.

REM 显示文件大小
for %%A in (bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe) do (
    set size=%%~zA
    set /a sizeInMB=!size! / 1048576
    echo 📊 文件大小: !sizeInMB! MB
)

echo.
echo 🎉 现在可以:
echo    1. 直接运行 FlomoQuickNote.exe
echo    2. 将exe复制到任意位置使用
echo    3. 分发给其他人使用
echo.
echo ═══════════════════════════════════════════════════════════
echo.

REM 询问是否立即运行
set /p RUNAPP="是否立即运行程序? (Y/N): "
if /i "%RUNAPP%"=="Y" (
    echo.
    echo 🚀 启动程序...
    start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
    echo.
    echo ✅ 程序已启动！请在系统托盘查找图标。
    timeout /t 3
) else (
    echo.
    echo 💡 您可以随时双击exe运行程序
)

echo.
pause

