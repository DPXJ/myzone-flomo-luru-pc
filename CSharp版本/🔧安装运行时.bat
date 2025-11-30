@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     安装 .NET Desktop Runtime (必需)                 ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

echo 🔍 检测到错误代码: -1073741571
echo.
echo 这个错误表示缺少 .NET Desktop Runtime
echo 虽然程序应该是自包含的，但 WinForms 应用需要额外的运行时
echo.
echo ═══════════════════════════════════════════════════════════
echo.

echo 📦 正在安装 .NET 6 Desktop Runtime...
echo.
echo 方式1: 使用 winget (推荐)
echo.

winget install Microsoft.DotNet.DesktopRuntime.6 --silent --accept-source-agreements --accept-package-agreements

if errorlevel 1 (
    echo.
    echo ⚠️  winget 安装失败，请使用方式2手动安装
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 📥 方式2: 手动下载安装
    echo.
    echo 请访问以下网址下载:
    echo https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    echo.
    echo 下载文件: 
    echo    ".NET Desktop Runtime 6.0.x - Windows x64"
    echo    (大约 55 MB)
    echo.
    echo 下载后双击安装，然后重新运行程序
    echo.
    
    REM 尝试打开下载页面
    set /p OPEN="是否在浏览器中打开下载页面? (Y/N): "
    if /i "%OPEN%"=="Y" (
        start https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    )
) else (
    echo.
    echo ╔═══════════════════════════════════════════════════════╗
    echo ║                                                       ║
    echo ║          ✅ 安装成功！                                ║
    echo ║                                                       ║
    echo ╚═══════════════════════════════════════════════════════╝
    echo.
    echo 现在可以启动程序了！
    echo.
    
    set /p RUN="是否立即启动程序? (Y/N): "
    if /i "%RUN%"=="Y" (
        cd /d "%~dp0"
        if exist "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe" (
            echo.
            echo 🚀 正在启动...
            start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
            timeout /t 2 >nul
            echo.
            echo ✅ 程序已启动！
            echo 💡 请在系统托盘（右下角）找到图标
            echo    点击右下角的 "^" 符号展开隐藏图标
        )
    )
)

echo.
pause

