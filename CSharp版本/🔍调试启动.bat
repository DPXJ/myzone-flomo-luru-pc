@echo off
chcp 65001 >nul
cls
cd /d "%~dp0"

echo ═══════════════════════════════════════════════════════════
echo             调试程序启动问题
echo ═══════════════════════════════════════════════════════════
echo.

set "EXE_PATH=bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"

echo [1] 检查程序文件是否存在...
if exist "%EXE_PATH%" (
    echo    ✅ 程序文件存在
    echo    📍 位置: %EXE_PATH%
    
    REM 获取文件信息
    for %%F in ("%EXE_PATH%") do (
        echo    📊 文件大小: %%~zF 字节
        echo    📅 修改时间: %%~tF
    )
) else (
    echo    ❌ 程序文件不存在！
    echo.
    pause
    exit /b 1
)
echo.

echo [2] 检查是否已经在运行...
tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I /N "FlomoQuickNote.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo    ⚠️  程序已在运行！
    echo.
    echo    如果看不到图标，请：
    echo    1. 点击屏幕右下角的 "^" 符号
    echo    2. 查看所有托盘图标
    echo    3. 或按 Ctrl+Alt+F 测试快捷键
    echo.
    pause
    exit /b 0
)
echo    ✅ 程序未运行
echo.

echo [3] 检查配置文件...
if exist "config.json" (
    echo    ✅ 配置文件存在
    type config.json
) else (
    echo    ℹ️  配置文件不存在（首次运行会自动创建）
)
echo.

echo [4] 尝试启动程序（带错误捕获）...
echo.
echo    如果程序崩溃或出错，会在这里显示错误信息
echo    请注意观察...
echo.
echo ───────────────────────────────────────────────────────────
echo.

REM 直接运行程序并等待
"%EXE_PATH%"

REM 如果程序立即退出，会到达这里
echo.
echo ───────────────────────────────────────────────────────────
echo.
echo ⚠️  程序已退出！
echo.
echo 退出代码: %ERRORLEVEL%
echo.

if %ERRORLEVEL% NEQ 0 (
    echo ❌ 程序异常退出 (错误代码: %ERRORLEVEL%^)
    echo.
    echo 可能的原因:
    echo    1. 缺少 .NET 运行时组件
    echo    2. 程序代码有错误
    echo    3. 缺少必要的 DLL 文件
    echo    4. 配置文件格式错误
) else (
    echo ℹ️  程序正常退出
)

echo.
echo 💡 如果一闪而过没看到错误，请：
echo    1. 检查上面是否有错误提示
echo    2. 尝试以管理员身份运行
echo    3. 查看 Windows 事件查看器的应用程序日志
echo.
pause

