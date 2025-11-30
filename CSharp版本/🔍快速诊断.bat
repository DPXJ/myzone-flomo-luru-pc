@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          🔍 诊断程序状态                              ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

echo [检查1] 查找程序进程...
echo.

tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I "FlomoQuickNote.exe" >NUL

if %ERRORLEVEL% EQU 0 (
    echo    ✅ 程序正在运行！
    echo.
    echo    进程详情:
    tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" /FO TABLE
    echo.
    echo    ═══════════════════════════════════════════════════════════
    echo.
    echo    💡 程序已启动，但您看不到托盘图标？
    echo.
    echo    【方法1】测试快捷键
    echo       → 直接按 Ctrl+Alt+F
    echo       → 如果弹出窗口，说明程序正常运行
    echo       → 只是图标被隐藏了
    echo.
    echo    【方法2】查找托盘图标
    echo       1. 看屏幕右下角（时间和日期旁边）
    echo       2. 找到一个向上的箭头 "^" 或 "∧"
    echo       3. 点击这个箭头
    echo       4. 会弹出隐藏的图标
    echo       5. 在里面找 "Flomo快速记录"
    echo.
    echo    【方法3】显示所有托盘图标
    echo       1. 右键点击任务栏空白处
    echo       2. 选择 "任务栏设置"
    echo       3. 找到 "选择哪些图标显示在任务栏上"
    echo       4. 打开 FlomoQuickNote 的开关
    echo.
    echo    【方法4】重启程序
    echo       1. 关闭程序（按任意键后选择 Y）
    echo       2. 重新运行 "以管理员身份运行.bat"
    echo.
    echo    ═══════════════════════════════════════════════════════════
    echo.
    
    set /p KILL="是否关闭程序重新启动? (Y/N): "
    if /i "%KILL%"=="Y" (
        echo.
        echo 正在关闭程序...
        taskkill /F /IM FlomoQuickNote.exe >NUL 2>&1
        timeout /t 2 >NUL
        echo ✅ 已关闭
        echo.
        echo 请重新运行 "以管理员身份运行.bat"
    )
    
) else (
    echo    ❌ 程序未运行！
    echo.
    echo    ═══════════════════════════════════════════════════════════
    echo.
    echo    【原因1】启动失败
    echo       可能性: 程序启动时出错
    echo.
    echo    【原因2】杀毒软件拦截
    echo       可能性: 被安全软件阻止
    echo.
    echo    【原因3】权限不足
    echo       可能性: 需要管理员权限
    echo.
    echo    ═══════════════════════════════════════════════════════════
    echo.
    echo    🔧 解决方案:
    echo.
    echo    方案1: 运行诊断启动脚本
    echo       → 双击: 🔍调试启动.bat
    echo       → 可以看到详细的错误信息
    echo.
    echo    方案2: 手动启动
    echo       位置: bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe
    echo       → 右键 → 以管理员身份运行
    echo.
    echo    方案3: 检查杀毒软件
    echo       → 查看是否有拦截提示
    echo       → 将程序添加到白名单
    echo.
    echo    ═══════════════════════════════════════════════════════════
    echo.
    
    set /p START="是否现在尝试启动程序? (Y/N): "
    if /i "%START%"=="Y" (
        echo.
        echo 正在启动...
        cd /d "%~dp0"
        if exist "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe" (
            start "" "bin\Release\net6.0-windows\win-x64\publish\FlomoQuickNote.exe"
            timeout /t 3 >NUL
            
            REM 再次检查
            tasklist /FI "IMAGENAME eq FlomoQuickNote.exe" 2>NUL | find /I "FlomoQuickNote.exe" >NUL
            if %ERRORLEVEL% EQU 0 (
                echo ✅ 启动成功！
                echo.
                echo 💡 按 Ctrl+Alt+F 测试是否正常工作
            ) else (
                echo ❌ 启动失败
                echo.
                echo 建议运行: 🔍调试启动.bat 查看错误详情
            )
        ) else (
            echo ❌ 找不到程序文件
        )
    )
)

echo.
echo ═══════════════════════════════════════════════════════════
echo.
pause

