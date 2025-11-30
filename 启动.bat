@echo off
title Flomo快速记录
echo ==========================================
echo    Flomo快速记录 - 启动中
echo ==========================================
echo.

REM 检查Python
python --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未检测到Python
    echo 请先安装Python 3.10+
    pause
    exit /b 1
)

echo Python已安装
echo.

REM 检查依赖
echo 检查依赖...
pip show PyQt6 >nul 2>&1
if errorlevel 1 (
    echo 正在安装依赖，请稍候...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo 依赖安装失败
        pause
        exit /b 1
    )
    echo 依赖安装完成
)

echo.
echo 启动应用...
echo ==========================================
echo.

REM 启动
python main.py

if errorlevel 1 (
    echo.
    echo 程序运行出错
    pause
)

