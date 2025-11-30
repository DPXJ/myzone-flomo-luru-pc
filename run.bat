@echo off
chcp 65001 >nul
echo ====================================
echo   Flomo快速记录 - 启动中...
echo ====================================
echo.

REM 检查Python是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.10+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo [信息] Python已安装
echo.

REM 检查是否安装依赖
echo [信息] 检查依赖...
pip show PyQt6 >nul 2>&1
if errorlevel 1 (
    echo [警告] 依赖未安装，正在安装...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
    echo [成功] 依赖安装完成
    echo.
)

echo [信息] 依赖检查通过
echo.
echo [信息] 启动应用...
echo ====================================
echo.

REM 启动应用
python main.py

if errorlevel 1 (
    echo.
    echo [错误] 程序运行出错
    pause
)

