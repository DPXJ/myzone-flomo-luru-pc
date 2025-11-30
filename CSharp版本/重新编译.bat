@echo off
chcp 65001 >nul
cls
cd /d "%~dp0"

echo ═══════════════════════════════════════════════════════════
echo            重新编译 Flomo 快速笔记
echo ═══════════════════════════════════════════════════════════
echo.

echo [步骤1] 关闭正在运行的程序...
taskkill /F /IM FlomoQuickNote.exe >nul 2>&1
if errorlevel 1 (
    echo    程序未运行
) else (
    echo    ✅ 已关闭旧程序
)
timeout /t 2 >nul
echo.

echo [步骤2] 清理旧文件...
if exist bin rd /s /q bin >nul 2>&1
if exist obj rd /s /q obj >nul 2>&1
echo    ✅ 清理完成
echo.

echo [步骤3] 开始编译...
echo.
"C:\Program Files\dotnet\dotnet.exe" publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true

if errorlevel 1 (
    echo.
    echo ❌ 编译失败
    echo.
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

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

if exist "%EXE_PATH%" (
    echo ✅ 程序位置: %EXE_PATH%
    echo.
    echo 🚀 现在可以运行程序测试修复后的设置窗口！
    echo.
    
    set /p RUN="是否立即启动? (Y/N): "
    if /i "%RUN%"=="Y" (
        echo.
        echo 正在启动...
        start "" "%EXE_PATH%"
        timeout /t 2 >nul
        echo ✅ 已启动！请打开设置窗口查看效果
    )
) else (
    echo ❌ 未找到生成的exe文件
)

echo.
pause

