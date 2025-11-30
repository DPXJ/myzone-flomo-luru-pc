@echo off
chcp 65001 >nul
cls
cd /d "%~dp0"

echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     修复运行时依赖问题并重新编译                     ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

echo 🔧 问题分析:
echo    错误代码 -1073741571 表示缺少运行时组件
echo    需要重新编译，使用更兼容的配置
echo.

REM 关闭旧程序
echo [1] 关闭旧程序...
taskkill /F /IM FlomoQuickNote.exe >nul 2>&1
echo    ✅ 完成
echo.

REM 清理
echo [2] 清理旧文件...
if exist bin rd /s /q bin >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1
echo    ✅ 完成
echo.

REM 查找 dotnet
set "DOTNET_EXE="
if exist "C:\Program Files\dotnet\dotnet.exe" (
    set "DOTNET_EXE=C:\Program Files\dotnet\dotnet.exe"
)

if "%DOTNET_EXE%"=="" (
    echo ❌ 未找到 .NET SDK
    pause
    exit /b 1
)

echo [3] 使用改进的编译配置...
echo.
echo    使用配置: Release
echo    目标平台: win-x64
echo    自包含: 是
echo    单文件: 否 (更兼容)
echo    裁剪: 否 (包含所有依赖)
echo.

REM 使用改进的发布配置
"%DOTNET_EXE%" publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=false -p:PublishReadyToRun=false -p:IncludeNativeLibrariesForSelfExtract=true -p:EnableCompressionInSingleFile=false

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

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if exist "%EXE_PATH%" (
    echo ✅ 程序位置: %EXE_PATH%
    echo.
    
    REM 检查 publish 目录内容
    echo 📦 包含文件数量:
    dir /b "%~dp0bin\Release\net6.0-windows\win-x64\publish" | find /c /v "" 
    echo.
    
    echo 💡 此次编译包含所有依赖的 DLL 文件
    echo    应该能够正常运行
    echo.
    
    set /p RUN="是否立即测试启动? (Y/N): "
    if /i "%RUN%"=="Y" (
        echo.
        echo 🚀 正在启动...
        echo.
        start "" "%EXE_PATH%"
        
        timeout /t 3 >nul
        
        REM 检查是否运行
        tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I /N "FlomoQuickNote.exe">NUL
        if "%ERRORLEVEL%"=="0" (
            echo ╔═══════════════════════════════════════════════════════╗
            echo ║              ✅ 程序启动成功！                        ║
            echo ╚═══════════════════════════════════════════════════════╝
            echo.
            echo 📍 请在系统托盘（右下角）找到图标
            echo    点击右下角的 "^" 符号展开隐藏图标
            echo.
        ) else (
            echo ❌ 程序仍然启动失败
            echo.
            echo 💡 建议安装 .NET Desktop Runtime:
            echo    运行: 🔧安装运行时.bat
        )
    )
) else (
    echo ❌ 未找到生成的exe文件
)

echo.
pause

