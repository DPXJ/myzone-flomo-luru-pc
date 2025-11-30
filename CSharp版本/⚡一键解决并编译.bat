@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     ⚡ 一键解决 .NET 问题并编译                      ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

echo [自动检测] 正在查找 .NET SDK...
echo.

REM 尝试常用路径
set "DOTNET_PATH1=C:\Program Files\dotnet\dotnet.exe"
set "DOTNET_PATH2=C:\Program Files (x86)\dotnet\dotnet.exe"
set "DOTNET_PATH3=%ProgramFiles%\dotnet\dotnet.exe"
set "DOTNET_PATH4=%ProgramFiles(x86)%\dotnet\dotnet.exe"
set "DOTNET_PATH5=%USERPROFILE%\.dotnet\dotnet.exe"
set "DOTNET_PATH6=%LOCALAPPDATA%\Microsoft\dotnet\dotnet.exe"

set DOTNET_EXE=
set FOUND=0

REM 按优先级检查
for %%P in ("%DOTNET_PATH1%" "%DOTNET_PATH3%" "%DOTNET_PATH2%" "%DOTNET_PATH4%" "%DOTNET_PATH5%" "%DOTNET_PATH6%") do (
    if exist %%P (
        set "DOTNET_EXE=%%~P"
        set FOUND=1
        goto :found
    )
)

:found
if %FOUND%==0 (
    echo ❌ 未找到 .NET SDK 安装
    echo.
    echo 可能的原因:
    echo    1. .NET SDK 安装失败或被取消
    echo    2. 安装到了非标准位置
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 📋 解决方法:
    echo.
    echo    请手动下载并安装 .NET 6 SDK:
    echo    https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
    echo.
    echo    下载 "Windows x64" 版本的 SDK 安装包
    echo    安装完成后，重新运行本脚本
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    pause
    exit /b 1
)

echo ✅ 找到 .NET SDK: %DOTNET_EXE%
echo.

REM 保存路径供其他脚本使用
echo %DOTNET_EXE%> dotnet_path.txt

REM 测试版本
echo [验证] 测试 .NET SDK 版本...
"%DOTNET_EXE%" --version >nul 2>&1
if errorlevel 1 (
    echo ❌ .NET SDK 无法正常运行
    echo.
    echo 建议重新安装 .NET 6 SDK
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('"%DOTNET_EXE%" --version') do set DOTNET_VERSION=%%i
echo ✅ .NET SDK 版本: %DOTNET_VERSION%
echo.

echo ═══════════════════════════════════════════════════════════
echo.
echo [编译] 开始编译项目...
echo.
echo ⏰ 这可能需要 1-2 分钟，请耐心等待...
echo    (首次编译会下载依赖包，时间较长)
echo.

REM 清理旧文件
if exist bin\Release rd /s /q bin\Release >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1

REM 还原依赖
echo [步骤1/2] 还原依赖包...
"%DOTNET_EXE%" restore
if errorlevel 1 (
    echo ❌ 依赖包还原失败
    echo.
    echo 可能是网络问题，请重试
    pause
    exit /b 1
)
echo ✅ 依赖包还原完成
echo.

REM 编译发布
echo [步骤2/2] 编译并发布...
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
echo ║            🎉🎉🎉 编译成功！🎉🎉🎉                  ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if exist "%EXE_PATH%" (
    echo 📦 程序已生成: %EXE_PATH%
    echo.
    
    REM 复制到根目录方便使用
    if not exist "发布版本" mkdir "发布版本"
    copy "%EXE_PATH%" "发布版本\FlomoQuickNote.exe" >nul 2>&1
    
    if exist "发布版本\FlomoQuickNote.exe" (
        echo ✅ 已复制到: 发布版本\FlomoQuickNote.exe
        echo.
    )
    
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 📖 使用指南:
    echo.
    echo    🔹 启动程序:
    echo       方式1: 双击 "以管理员身份运行.bat"
    echo       方式2: 直接运行 "%EXE_PATH%"
    echo.
    echo    🔹 首次配置:
    echo       1. 程序启动后会出现在系统托盘（右下角）
    echo       2. 右键托盘图标 → 点击"设置"
    echo       3. 输入你的 Flomo API 地址
    echo       4. 点击"保存"
    echo.
    echo    🔹 日常使用:
    echo       1. 按快捷键 Ctrl+Alt+F（可在设置中修改）
    echo       2. 在弹出的窗口输入笔记内容
    echo       3. 点击"发送"即可同步到 Flomo
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    
    set /p START="是否立即启动程序? (Y/N): "
    if /i "%START%"=="Y" (
        echo.
        echo 🚀 正在启动 Flomo 快速笔记...
        echo.
        echo 💡 提示: 请在系统托盘（屏幕右下角）找到应用图标
        echo.
        
        start "" "%EXE_PATH%"
        
        timeout /t 3 >nul
        echo ✅ 程序已启动！
        echo.
        echo 📌 记得先配置 Flomo API 哦！
        echo    右键托盘图标 → 设置 → 输入 API 地址
        echo.
    ) else (
        echo.
        echo 👍 好的！你可以随时双击 "以管理员身份运行.bat" 来启动程序
        echo.
    )
) else (
    echo ❌ 未找到生成的exe文件
    echo.
    echo 预期位置: %EXE_PATH%
    echo.
)

echo.
echo ═══════════════════════════════════════════════════════════
echo  编译完成！按任意键退出...
echo ═══════════════════════════════════════════════════════════
pause >nul

