@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     推送项目到 GitHub                                ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.

REM 检查是否安装了 Git
git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到 Git
    echo.
    echo 请先安装 Git:
    echo https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo ✅ Git 已安装
echo.

REM 设置远程仓库地址
set REPO_URL=https://github.com/DPXJ/myzone-flomo-luru-pc.git

echo [1/6] 初始化 Git 仓库...
if not exist .git (
    git init
    echo ✅ Git 仓库初始化完成
) else (
    echo ✅ Git 仓库已存在
)
echo.

echo [2/6] 添加所有文件...
git add .
echo ✅ 文件已添加
echo.

echo [3/6] 提交更改...
git commit -m "feat: Flomo快速记录应用 - 包含Python和C#两个版本

- Python版本: PyQt6实现，功能完整
- C#版本: WinForms实现，超级稳定
- 支持全局快捷键
- 支持系统托盘常驻
- 支持Flomo API同步
- 完整的配置管理
- 详细的使用文档"

if errorlevel 1 (
    echo ⚠️ 没有新的更改需要提交（或已经提交过）
) else (
    echo ✅ 更改已提交
)
echo.

echo [4/6] 添加远程仓库...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%
echo ✅ 远程仓库已添加
echo.

echo [5/6] 创建主分支...
git branch -M main
echo ✅ 主分支已创建
echo.

echo [6/6] 推送到 GitHub...
echo.
echo 💡 提示: 如果需要登录，请输入您的 GitHub 用户名和密码
echo    （或使用 Personal Access Token）
echo.

git push -u origin main

if errorlevel 1 (
    echo.
    echo ❌ 推送失败
    echo.
    echo 可能的原因:
    echo 1. 需要登录 GitHub（输入用户名和密码/Token）
    echo 2. 仓库不存在或无权限访问
    echo 3. 网络连接问题
    echo.
    echo 💡 如果需要使用 Token:
    echo    1. 访问: https://github.com/settings/tokens
    echo    2. 生成新的 Token（勾选 repo 权限）
    echo    3. 使用 Token 代替密码
    echo.
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║              ✅ 推送成功！                            ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.
echo 🎉 您的项目已成功推送到 GitHub:
echo    %REPO_URL%
echo.
echo 💡 现在可以:
echo    1. 访问仓库查看代码
echo    2. 与他人分享项目
echo    3. 继续开发和更新
echo.
pause

