@echo off
chcp 65001 >nul
cls
echo ==========================================
echo    一键修复安装
echo ==========================================
echo.

echo [1/4] 升级pip...
python -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
echo.

echo [2/4] 安装PyQt6...
pip install PyQt6 -i https://pypi.tuna.tsinghua.edu.cn/simple
echo.

echo [3/4] 安装keyboard...
pip install keyboard -i https://pypi.tuna.tsinghua.edu.cn/simple
echo.

echo [4/4] 安装requests...
pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple
echo.

echo ==========================================
echo 安装完成！现在可以启动应用了
echo ==========================================
echo.
echo 按任意键启动应用...
pause >nul

cls
echo 正在启动应用...
echo.
python main.py
pause

