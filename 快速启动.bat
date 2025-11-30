@echo off
title Flomo快速记录
cls
echo ==========================================
echo    Flomo快速记录
echo ==========================================
echo.
echo 正在启动应用...
echo.

python main.py

if errorlevel 1 (
    echo.
    echo 程序运行出错，请检查：
    echo 1. 是否已安装依赖（运行 安装依赖.bat）
    echo 2. 是否已配置Flomo API地址
    pause
)

