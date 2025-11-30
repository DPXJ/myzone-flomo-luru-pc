@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     安装 .NET 6 SDK                                  ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo 您需要安装 .NET 6 SDK 才能编译 C# 项目
echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo 方式1: 自动下载并安装（推荐）
echo.
echo ═══════════════════════════════════════════════════════════
echo.

set /p AUTO="是否自动打开下载页面? (Y/N): "
if /i "%AUTO%"=="Y" (
    echo.
    echo 正在打开下载页面...
    start https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    echo.
    echo ✅ 已打开下载页面
    echo.
    echo 请下载并安装:
    echo 「.NET 6.0 SDK x64」(Windows 64位)
    echo.
    echo 安装完成后重新运行 build.bat
    echo.
) else (
    echo.
    echo 手动下载地址:
    echo https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    echo.
    echo 请下载: .NET 6.0 SDK x64
    echo.
)

echo ═══════════════════════════════════════════════════════════
echo.
echo 方式2: 使用 winget 命令安装（快速）
echo.
echo ═══════════════════════════════════════════════════════════
echo.

set /p WINGET="是否使用 winget 安装? (Y/N): "
if /i "%WINGET%"=="Y" (
    echo.
    echo 正在安装 .NET 6 SDK...
    echo.
    winget install Microsoft.DotNet.SDK.6
    
    if errorlevel 1 (
        echo.
        echo ❌ 安装失败
        echo 请使用方式1手动安装
    ) else (
        echo.
        echo ✅ 安装成功！
        echo.
        echo 请关闭当前命令行窗口，重新打开后运行 build.bat
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo 💡 安装完成后:
echo    1. 关闭当前命令行窗口
echo    2. 重新打开命令行
echo    3. 运行: dotnet --version （验证安装）
echo    4. 运行: build.bat （重新编译）
echo.
echo ═══════════════════════════════════════════════════════════
echo.
pause

