using System;
using System.Drawing;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    public class TestApp : ApplicationContext
    {
        private NotifyIcon trayIcon;
        
        public TestApp()
        {
            // 最简化的托盘应用
            trayIcon = new NotifyIcon();
            trayIcon.Icon = SystemIcons.Application;
            trayIcon.Text = "Test App";
            trayIcon.Visible = true;
            
            trayIcon.DoubleClick += (s, e) =>
            {
                MessageBox.Show("Test App is running!", "Test");
            };
            
            var contextMenu = new ContextMenuStrip();
            var exitItem = new ToolStripMenuItem("Exit");
            exitItem.Click += (s, e) =>
            {
                trayIcon.Visible = false;
                Application.Exit();
            };
            contextMenu.Items.Add(exitItem);
            trayIcon.ContextMenuStrip = contextMenu;
            
            MessageBox.Show("Test App Started!\n\nYou should see a tray icon now.", "Test", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}

