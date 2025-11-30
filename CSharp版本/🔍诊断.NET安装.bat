@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          诊断 .NET SDK 安装状态                      ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.

echo [检查1] 尝试使用 dotnet 命令...
echo.
dotnet --version 2>nul
if errorlevel 1 (
    echo ❌ dotnet 命令不可用
) else (
    echo ✅ dotnet 命令可用
    goto :success
)
echo.

echo [检查2] 查找 .NET SDK 安装路径...
echo.

set "DOTNET_PATH1=C:\Program Files\dotnet\dotnet.exe"
set "DOTNET_PATH2=C:\Program Files (x86)\dotnet\dotnet.exe"
set "DOTNET_PATH3=%ProgramFiles%\dotnet\dotnet.exe"
set "DOTNET_PATH4=%ProgramFiles(x86)%\dotnet\dotnet.exe"

set FOUND=0

if exist "%DOTNET_PATH1%" (
    echo ✅ 找到了！位置: %DOTNET_PATH1%
    set "DOTNET_EXE=%DOTNET_PATH1%"
    set FOUND=1
) else if exist "%DOTNET_PATH2%" (
    echo ✅ 找到了！位置: %DOTNET_PATH2%
    set "DOTNET_EXE=%DOTNET_PATH2%"
    set FOUND=1
) else if exist "%DOTNET_PATH3%" (
    echo ✅ 找到了！位置: %DOTNET_PATH3%
    set "DOTNET_EXE=%DOTNET_PATH3%"
    set FOUND=1
) else if exist "%DOTNET_PATH4%" (
    echo ✅ 找到了！位置: %DOTNET_PATH4%
    set "DOTNET_EXE=%DOTNET_PATH4%"
    set FOUND=1
) else (
    echo ❌ 未找到 .NET SDK 安装文件
    echo.
    echo 这意味着 .NET SDK 可能没有正确安装。
    echo.
    goto :not_installed
)

echo.
echo [检查3] 测试 .NET SDK 版本...
echo.
"%DOTNET_EXE%" --version
if errorlevel 1 (
    echo ❌ .NET SDK 无法运行
    goto :not_installed
)

echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     ✅ .NET SDK 已安装，但环境变量未生效            ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.
echo 💡 解决方案：
echo.
echo    方案1 (推荐): 重启电脑
echo           → 这会让环境变量生效
echo           → 重启后运行: 验证安装并编译.bat
echo.
echo    方案2: 使用「直接编译(无需重启).bat」
echo           → 我会创建一个不依赖环境变量的编译脚本
echo           → 可以立即编译，无需重启
echo.
set /p CHOICE="选择方案 (1=重启后再编译 / 2=立即编译): "
if "%CHOICE%"=="2" goto :create_direct_build
if "%CHOICE%"=="1" (
    echo.
    echo 👉 请重启电脑后，运行: CSharp版本\验证安装并编译.bat
    echo.
    pause
    exit /b 0
)
goto :create_direct_build

:create_direct_build
echo.
echo 正在创建直接编译脚本...

REM 保存 dotnet 路径到文件
echo %DOTNET_EXE%> "%~dp0dotnet_path.txt"

echo ✅ 已创建！
echo.
echo 👉 请运行: CSharp版本\直接编译(无需重启).bat
echo.
pause
exit /b 0

:not_installed
echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          ❌ .NET SDK 未正确安装                      ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.
echo 📋 请重新安装 .NET SDK:
echo.
echo    方法1: 使用 winget (推荐)
echo           winget install Microsoft.DotNet.SDK.6
echo.
echo    方法2: 手动下载安装
echo           https://dotnet.microsoft.com/zh-cn/download/dotnet/6.0
echo           下载 ".NET 6.0 SDK x64" 并安装
echo.
echo 💡 安装完成后:
echo    1. 重启电脑
echo    2. 运行本诊断脚本验证
echo.
pause
exit /b 1

:success
echo.
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║          ✅ .NET SDK 正常工作                        ║
echo ║                                                       ║
echo ╚═══════════════════════════════════════════════════════╝
echo.
echo 👉 可以直接运行: 验证安装并编译.bat
echo.
pause
exit /b 0

