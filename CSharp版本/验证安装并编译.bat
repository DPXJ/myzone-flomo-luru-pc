@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     验证 .NET SDK 安装并编译项目                     ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.

echo [步骤1] 验证 .NET SDK 安装...
echo.

dotnet --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 仍未检测到 .NET SDK
    echo.
    echo 💡 可能的原因:
    echo    1. 您还在使用旧的命令行窗口
    echo    2. 安装未完全完成
    echo.
    echo 📋 解决方法:
    echo    1. 完全关闭当前命令行窗口（点击 X 关闭）
    echo    2. 重新打开一个新的命令行窗口
    echo    3. 进入项目目录
    echo    4. 再次运行本脚本
    echo.
    echo 或者:
    echo    重启电脑后再试
    echo.
    pause
    exit /b 1
)

echo ✅ .NET SDK 已正确安装！
for /f "tokens=*" %%i in ('dotnet --version') do set DOTNET_VERSION=%%i
echo    版本: %DOTNET_VERSION%
echo.

echo ═══════════════════════════════════════════════════════════
echo.
echo [步骤2] 开始编译项目...
echo.
echo 这可能需要 1-2 分钟，请耐心等待...
echo.

REM 清理旧文件
if exist bin\Release rd /s /q bin\Release >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1

REM 还原依赖
echo [2.1] 还原依赖包...
dotnet restore
if errorlevel 1 (
    echo ❌ 依赖包还原失败
    pause
    exit /b 1
)
echo ✅ 依赖包还原完成
echo.

REM 编译发布
echo [2.2] 编译发布（这是最耗时的步骤）...
echo.
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
if errorlevel 1 (
    echo.
    echo ❌ 编译失败
    echo.
    echo 请检查错误信息，或联系支持
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║              ✅ 编译成功！                            ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo 📦 生成的exe位置:
echo    bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe
echo.

REM 检查文件是否存在
if exist "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe" (
    for %%A in (bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe) do (
        set size=%%~zA
        set /a sizeInMB=!size! / 1048576
    )
    echo 📊 文件大小: 约 15-20 MB
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 🎉 下一步:
    echo    1. 双击运行: 以管理员身份运行.bat
    echo    2. 在系统托盘找到图标
    echo    3. 右键 → 设置 → 配置 Flomo API
    echo    4. 按 Ctrl+Alt+F 开始使用！
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    
    set /p RUNAPP="是否立即启动应用? (Y/N): "
    if /i "!RUNAPP!"=="Y" (
        echo.
        echo 🚀 正在以管理员权限启动...
        echo.
        
        REM 检查是否有管理员权限
        net session >nul 2>&1
        if errorlevel 1 (
            echo 💡 需要管理员权限来注册全局热键
            echo    请使用「以管理员身份运行.bat」启动
            echo.
            start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
        ) else (
            start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
        )
        
        echo ✅ 应用已启动！
        echo 💡 请在系统托盘（右下角）找到应用图标
        timeout /t 3
    )
) else (
    echo ❌ 未找到生成的exe文件
    echo 可能编译过程出现问题
)

echo.
pause

