@echo off
chcp 65001 >nul
echo ====================================
echo   Flomo快速记录 - 打包脚本
echo ====================================
echo.

echo [信息] 开始打包...
python build.py

if errorlevel 1 (
    echo.
    echo [错误] 打包失败
    pause
    exit /b 1
)

echo.
echo [成功] 打包完成！
pause

