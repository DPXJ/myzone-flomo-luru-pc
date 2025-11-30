using System;
using System.Drawing;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    /// <summary>
    /// 主应用程序类
    /// </summary>
    public class FlomoApp : ApplicationContext
    {
        private NotifyIcon trayIcon;
        private MainForm mainForm;
        private SettingsForm settingsForm;
        private ConfigManager config;
        private GlobalHotkey hotkey;
        
        private bool initialized = false;
        
        public FlomoApp()
        {
            // 初始化配置
            config = new ConfigManager();
            
            // 初始化窗体
            mainForm = new MainForm(config);
            settingsForm = new SettingsForm(config);
            
            // 初始化系统托盘
            InitializeTrayIcon();
            
            // 延迟注册热键，确保消息循环已经建立
            EventHandler idleHandler = null;
            idleHandler = (s, e) =>
            {
                if (!initialized)
                {
                    initialized = true;
                    Application.Idle -= idleHandler; // 取消订阅
                    
                    // 注册热键
                    RegisterHotkey();
                    
                    // 显示启动消息
                    trayIcon.ShowBalloonTip(3000, 
                        "Flomo快速记录", 
                        $"已启动！按 {config.Hotkey.ToUpper()} 快速记录",
                        ToolTipIcon.Info);
                }
            };
            Application.Idle += idleHandler;
        }
        
        private void InitializeTrayIcon()
        {
            trayIcon = new NotifyIcon();
            trayIcon.Icon = SystemIcons.Application; // 可以替换为自定义图标
            trayIcon.Text = "Flomo快速记录";
            trayIcon.Visible = true;
            
            // 双击托盘图标
            trayIcon.DoubleClick += (s, e) => ShowMainForm();
            
            // 创建右键菜单
            var contextMenu = new ContextMenuStrip();
            
            var openItem = new ToolStripMenuItem("📝 打开输入窗口 (" + config.Hotkey.ToUpper() + ")");
            openItem.Click += (s, e) => ShowMainForm();
            openItem.Font = new System.Drawing.Font(openItem.Font, System.Drawing.FontStyle.Bold);
            contextMenu.Items.Add(openItem);
            
            contextMenu.Items.Add(new ToolStripSeparator());
            
            var settingsItem = new ToolStripMenuItem("⚙️ 设置");
            settingsItem.Click += (s, e) => ShowSettings();
            contextMenu.Items.Add(settingsItem);
            
            var aboutItem = new ToolStripMenuItem("ℹ️ 关于");
            aboutItem.Click += (s, e) => ShowAbout();
            contextMenu.Items.Add(aboutItem);
            
            contextMenu.Items.Add(new ToolStripSeparator());
            
            var exitItem = new ToolStripMenuItem("🚪 退出");
            exitItem.Click += (s, e) => ExitApp();
            contextMenu.Items.Add(exitItem);
            
            trayIcon.ContextMenuStrip = contextMenu;
        }
        
        private void RegisterHotkey()
        {
            try
            {
                hotkey = new GlobalHotkey(config.Hotkey, ShowMainForm);
                hotkey.Register();
                System.Diagnostics.Debug.WriteLine("热键注册成功");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"热键注册失败: {ex.Message}");
                
                // 使用Invoke确保在UI线程显示消息框
                trayIcon.BalloonTipIcon = ToolTipIcon.Warning;
                trayIcon.BalloonTipTitle = "快捷键注册失败";
                trayIcon.BalloonTipText = "无法注册快捷键，可能被占用或需要管理员权限\n\n可以在设置中更换";
                trayIcon.ShowBalloonTip(5000);
                
                // 注册失败不应该导致程序退出，继续运行
            }
        }
        
        private void ShowMainForm()
        {
            mainForm.ShowAndFocus();
        }
        
        private void ShowSettings()
        {
            // 设置改变时重新注册热键
            settingsForm.OnSettingsSaved = () =>
            {
                config.Load();
                hotkey?.Unregister();
                RegisterHotkey();
            };
            
            settingsForm.ShowDialog();
        }
        
        private void ShowAbout()
        {
            MessageBox.Show(
                "Flomo快速记录 v1.0.0\n\n" +
                "通过全局快捷键快速记录笔记到Flomo\n\n" +
                "功能特性：\n" +
                "• 全局快捷键快速唤起\n" +
                "• 支持标签管理\n" +
                "• 系统托盘常驻\n" +
                "• 轻量级设计\n\n" +
                "技术栈：C# WinForms + .NET 6",
                "关于 Flomo快速记录",
                MessageBoxButtons.OK,
                MessageBoxIcon.Information);
        }
        
        private void ExitApp()
        {
            var result = MessageBox.Show(
                "确定要退出 Flomo快速记录吗？",
                "确认退出",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question);
            
            if (result == DialogResult.Yes)
            {
                hotkey?.Unregister();
                trayIcon.Visible = false;
                trayIcon.Dispose();
                Application.Exit();
            }
        }
    }
}

