using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    /// <summary>
    /// 全局热键管理类
    /// </summary>
    public class GlobalHotkey : IDisposable
    {
        [DllImport("user32.dll")]
        private static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
        
        [DllImport("user32.dll")]
        private static extern bool UnregisterHotKey(IntPtr hWnd, int id);
        
        private const int WM_HOTKEY = 0x0312;
        private const int HOTKEY_ID = 9000;
        
        // 修饰键
        private enum KeyModifiers : uint
        {
            None = 0,
            Alt = 1,
            Control = 2,
            Shift = 4,
            Win = 8
        }
        
        private readonly HotkeyWindow window;
        private readonly Action callback;
        private bool registered = false;
        
        public GlobalHotkey(string hotkey, Action callback)
        {
            this.callback = callback;
            this.window = new HotkeyWindow(this);
            
            // 解析热键字符串
            ParseHotkey(hotkey, out uint modifiers, out uint key);
            this.window.Modifiers = modifiers;
            this.window.Key = key;
        }
        
        public void Register()
        {
            if (!registered)
            {
                // 确保窗口句柄已创建
                if (window.Handle == IntPtr.Zero)
                {
                    throw new Exception("窗口句柄未创建");
                }
                
                bool success = RegisterHotKey(
                    window.Handle,
                    HOTKEY_ID,
                    window.Modifiers,
                    window.Key);
                
                if (!success)
                {
                    int errorCode = System.Runtime.InteropServices.Marshal.GetLastWin32Error();
                    string errorMsg = $"无法注册全局热键\n\n";
                    errorMsg += "可能原因:\n";
                    errorMsg += "1. 快捷键被其他程序占用\n";
                    errorMsg += "2. 需要管理员权限运行\n";
                    errorMsg += "3. 在设置中更换其他快捷键\n\n";
                    errorMsg += $"错误代码: {errorCode}";
                    throw new Exception(errorMsg);
                }
                
                registered = true;
                System.Diagnostics.Debug.WriteLine($"热键注册成功: Modifiers={window.Modifiers}, Key={window.Key}");
            }
        }
        
        public void Unregister()
        {
            if (registered)
            {
                UnregisterHotKey(window.Handle, HOTKEY_ID);
                registered = false;
            }
        }
        
        private void OnHotkeyPressed()
        {
            callback?.Invoke();
        }
        
        private void ParseHotkey(string hotkey, out uint modifiers, out uint key)
        {
            modifiers = 0;
            key = 0;
            
            string[] parts = hotkey.ToLower().Split('+');
            
            foreach (string part in parts)
            {
                string trimmed = part.Trim();
                
                switch (trimmed)
                {
                    case "ctrl":
                    case "control":
                        modifiers |= (uint)KeyModifiers.Control;
                        break;
                    case "alt":
                        modifiers |= (uint)KeyModifiers.Alt;
                        break;
                    case "shift":
                        modifiers |= (uint)KeyModifiers.Shift;
                        break;
                    case "win":
                        modifiers |= (uint)KeyModifiers.Win;
                        break;
                    default:
                        // 解析按键
                        key = GetVirtualKeyCode(trimmed);
                        break;
                }
            }
        }
        
        private uint GetVirtualKeyCode(string key)
        {
            // 字母键
            if (key.Length == 1 && char.IsLetter(key[0]))
            {
                return (uint)char.ToUpper(key[0]);
            }
            
            // 数字键
            if (key.Length == 1 && char.IsDigit(key[0]))
            {
                return (uint)key[0];
            }
            
            // 功能键
            switch (key)
            {
                case "f1": return 0x70;
                case "f2": return 0x71;
                case "f3": return 0x72;
                case "f4": return 0x73;
                case "f5": return 0x74;
                case "f6": return 0x75;
                case "f7": return 0x76;
                case "f8": return 0x77;
                case "f9": return 0x78;
                case "f10": return 0x79;
                case "f11": return 0x7A;
                case "f12": return 0x7B;
                case "space": return 0x20;
                case "enter": return 0x0D;
                case "esc": return 0x1B;
                case "tab": return 0x09;
                default: return 0;
            }
        }
        
        public void Dispose()
        {
            Unregister();
            window?.Dispose();
        }
        
        // 内部窗口类，用于接收热键消息
        private class HotkeyWindow : NativeWindow, IDisposable
        {
            private readonly GlobalHotkey parent;
            
            public uint Modifiers { get; set; }
            public uint Key { get; set; }
            
            public HotkeyWindow(GlobalHotkey parent)
            {
                this.parent = parent;
                CreateHandle(new CreateParams());
            }
            
            protected override void WndProc(ref Message m)
            {
                if (m.Msg == WM_HOTKEY)
                {
                    parent.OnHotkeyPressed();
                }
                
                base.WndProc(ref m);
            }
            
            public void Dispose()
            {
                DestroyHandle();
            }
        }
    }
}

