@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          直接编译 Flomo 快速笔记                     ║
echo ║          (无需重启电脑)                              ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

REM 检查是否已运行诊断脚本
if not exist "dotnet_path.txt" (
    echo ❌ 请先运行: 🔍诊断.NET安装.bat
    echo.
    echo 诊断脚本会自动找到 .NET SDK 的位置
    echo.
    pause
    exit /b 1
)

REM 读取 dotnet 路径
set /p DOTNET_EXE=<dotnet_path.txt

if not exist "%DOTNET_EXE%" (
    echo ❌ .NET SDK 路径无效: %DOTNET_EXE%
    echo.
    echo 请重新运行: 🔍诊断.NET安装.bat
    echo.
    pause
    exit /b 1
)

echo ✅ 找到 .NET SDK: %DOTNET_EXE%
echo.

REM 验证版本
echo [步骤1] 验证 .NET SDK...
"%DOTNET_EXE%" --version
if errorlevel 1 (
    echo ❌ .NET SDK 无法运行
    pause
    exit /b 1
)
echo.

echo ═══════════════════════════════════════════════════════════
echo.
echo [步骤2] 开始编译项目...
echo.
echo ⏰ 预计需要 1-2 分钟，请耐心等待...
echo.

REM 清理旧文件
if exist bin\Release rd /s /q bin\Release >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1

REM 还原依赖
echo [2.1] 还原依赖包...
"%DOTNET_EXE%" restore
if errorlevel 1 (
    echo ❌ 依赖包还原失败
    pause
    exit /b 1
)
echo ✅ 依赖包还原完成
echo.

REM 编译发布
echo [2.2] 编译发布（最耗时的步骤）...
echo.
"%DOTNET_EXE%" publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true -p:DebugType=None -p:DebugSymbols=false
if errorlevel 1 (
    echo.
    echo ❌ 编译失败
    echo.
    echo 请检查上面的错误信息
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║              🎉 编译成功！                            ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

REM 查找生成的exe
set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if exist "%EXE_PATH%" (
    echo ✅ 程序位置: %EXE_PATH%
    echo.
    
    REM 显示文件大小
    for %%A in ("%EXE_PATH%") do (
        set size=%%~zA
    )
    echo 📊 文件大小: %size% 字节
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 🚀 下一步:
    echo.
    echo    1. 运行程序: 以管理员身份运行.bat
    echo.
    echo    2. 配置 API:
    echo       → 在系统托盘找到应用图标
    echo       → 右键 → 设置
    echo       → 输入 Flomo API 地址
    echo.
    echo    3. 开始使用:
    echo       → 按 Ctrl+Alt+F 唤起输入框
    echo       → 输入内容后点击发送
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    
    set /p RUN="是否立即启动应用? (Y/N): "
    if /i "%RUN%"=="Y" (
        echo.
        echo 🚀 正在启动...
        echo 💡 请在系统托盘（右下角）找到应用图标
        echo.
        
        start "" "%EXE_PATH%"
        
        timeout /t 2 >nul
        echo ✅ 应用已启动！
        echo.
        echo 📌 提示: 首次使用需要先配置 Flomo API
        echo          右键托盘图标 → 设置
        echo.
    )
) else (
    echo ❌ 未找到生成的exe文件
    echo.
    echo 预期位置: %EXE_PATH%
    echo.
    echo 请检查编译过程是否有错误
)

echo.
pause

