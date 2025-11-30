using System;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            
            // 检查是否已经运行
            bool createdNew;
            using (var mutex = new System.Threading.Mutex(true, "FlomoQuickNote_SingleInstance", out createdNew))
            {
                if (!createdNew)
                {
                    MessageBox.Show("应用程序已经在运行中！\n\n请在系统托盘查找图标。", 
                        "Flomo快速记录", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return;
                }
                
                try
                {
                    // 启动应用
                    var app = new FlomoApp();
                    Application.Run();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"程序启动失败：\n\n{ex.Message}", 
                        "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }
    }
}

