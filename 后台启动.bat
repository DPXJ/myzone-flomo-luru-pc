@echo off
title Flomo快速记录 - 后台启动
cls
echo ==========================================
echo    Flomo快速记录 - 后台启动
echo ==========================================
echo.
echo 正在后台启动应用...
echo.
echo 启动后：
echo - 应用将在系统托盘（右下角）运行
echo - 本窗口会自动关闭
echo - 按 Ctrl+Alt+F 唤起输入窗口
echo.
echo ==========================================
echo.

REM 使用pythonw.exe后台启动，不显示命令行窗口
start "" pythonw.exe main.py

timeout /t 2 /nobreak >nul
echo.
echo 应用已在后台启动！
echo 请在系统托盘（右下角）找到应用图标
echo.
echo 本窗口将在3秒后自动关闭...
timeout /t 3 /nobreak >nul
exit

