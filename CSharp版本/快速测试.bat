@echo off
chcp 65001 >nul
cls
echo ╔═══════════════════════════════════════════════════════╗
echo ║                                                       ║
echo ║     热键测试程序                                     ║
echo ║                                                       ║
╚═══════════════════════════════════════════════════════╝
echo.

echo 这个脚本会检测热键是否被占用
echo.

echo [测试] 尝试注册 Ctrl+Alt+F...
echo.

powershell -Command "Add-Type -TypeDefinition @'^
using System;
using System.Runtime.InteropServices;
public class HotkeyTest {
    [DllImport(\"user32.dll\")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    [DllImport(\"user32.dll\")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
}
'^; try { $result = [HotkeyTest]::RegisterHotKey([IntPtr]::Zero, 9000, 0x3, 0x46); if ($result) { Write-Host '✅ 热键可以注册！Ctrl+Alt+F 未被占用'; [HotkeyTest]::UnregisterHotKey([IntPtr]::Zero, 9000) } else { Write-Host '❌ 热键已被占用！Ctrl+Alt+F 被其他程序使用' } } catch { Write-Host '❌ 测试失败' }"

echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo 💡 如果热键被占用，请:
echo    1. 在设置中更换其他快捷键
echo    2. 检查哪个程序占用了该快捷键
echo    3. 尝试 Ctrl+Shift+F 或 Alt+F 等
echo.
pause

