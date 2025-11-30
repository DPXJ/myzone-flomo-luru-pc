@echo off
title 安装依赖
echo ==========================================
echo    安装Flomo快速记录所需依赖
echo ==========================================
echo.

echo 步骤1: 升级pip和setuptools
echo.
python -m pip install --upgrade pip setuptools wheel
echo.

echo 步骤2: 安装PyQt6
echo.
pip install PyQt6==6.6.1
echo.

echo 步骤3: 安装其他依赖
echo.
pip install requests==2.31.0
pip install keyboard==0.13.5
pip install Pillow==10.1.0
pip install pynput==1.7.6
echo.

echo ==========================================
echo 安装完成！
echo ==========================================
echo.
pause

