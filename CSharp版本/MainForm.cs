using System;
using System.Drawing;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    /// <summary>
    /// 主输入窗口
    /// </summary>
    public partial class MainForm : Form
    {
        private ConfigManager config;
        private TextBox contentTextBox;
        private TextBox tagsTextBox;
        private Button sendButton;
        private Button cancelButton;
        
        public MainForm(ConfigManager configManager)
        {
            this.config = configManager;
            InitializeComponent();
        }
        
        private void InitializeComponent()
        {
            // 窗体属性
            this.Text = "快速记录到 Flomo";
            this.ClientSize = new Size(520, 380);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.TopMost = true;
            this.ShowInTaskbar = false;
            this.BackColor = Color.White;
            this.ForeColor = Color.Black;
            this.Font = new Font("Microsoft YaHei UI", 9F, FontStyle.Regular);
            
            // 标题标签
            var titleLabel = new Label
            {
                Text = "✍️ 快速记录到 Flomo",
                Location = new Point(20, 20),
                Size = new Size(480, 30),
                Font = new Font("Microsoft YaHei UI", 12F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(titleLabel);
            
            // 内容输入框
            contentTextBox = new TextBox
            {
                Location = new Point(20, 60),
                Size = new Size(460, 160),
                Multiline = true,
                ScrollBars = ScrollBars.Vertical,
                Font = new Font("Microsoft YaHei UI", 10F, FontStyle.Regular),
                BorderStyle = BorderStyle.FixedSingle,
                BackColor = Color.White,
                ForeColor = Color.Black
            };
            contentTextBox.KeyDown += ContentTextBox_KeyDown;
            this.Controls.Add(contentTextBox);
            
            // 提示标签
            var tipLabel = new Label
            {
                Text = "💡 按 Ctrl+Enter 快速发送  |  按 ESC 关闭窗口",
                Location = new Point(20, 228),
                Size = new Size(460, 20),
                ForeColor = Color.Gray,
                BackColor = Color.Transparent,
                Font = new Font("Microsoft YaHei UI", 8F, FontStyle.Regular)
            };
            this.Controls.Add(tipLabel);
            
            // 标签区域
            var tagLabel = new Label
            {
                Text = "🏷️ 标签:",
                Location = new Point(20, 258),
                Size = new Size(60, 25),
                Font = new Font("Microsoft YaHei UI", 9F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.Transparent,
                TextAlign = ContentAlignment.MiddleLeft
            };
            this.Controls.Add(tagLabel);
            
            tagsTextBox = new TextBox
            {
                Location = new Point(85, 258),
                Size = new Size(395, 25),
                Font = new Font("Microsoft YaHei UI", 9F, FontStyle.Regular),
                BorderStyle = BorderStyle.FixedSingle,
                BackColor = Color.White,
                ForeColor = Color.Black,
                Text = config.LastTags
            };
            tagsTextBox.KeyDown += TagsTextBox_KeyDown;
            this.Controls.Add(tagsTextBox);
            
            // 按钮区域
            cancelButton = new Button
            {
                Text = "取消 (ESC)",
                Location = new Point(280, 300),
                Size = new Size(95, 35),
                Font = new Font("Microsoft YaHei UI", 9F),
                BackColor = Color.FromArgb(240, 240, 240),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            cancelButton.FlatAppearance.BorderColor = Color.FromArgb(200, 200, 200);
            cancelButton.Click += (s, e) => this.Hide();
            this.Controls.Add(cancelButton);
            
            sendButton = new Button
            {
                Text = "发送 (Ctrl+Enter)",
                Location = new Point(385, 300),
                Size = new Size(95, 35),
                Font = new Font("Microsoft YaHei UI", 9F, FontStyle.Bold),
                BackColor = Color.FromArgb(74, 144, 226),
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            sendButton.FlatAppearance.BorderSize = 0;
            sendButton.Click += SendButton_Click;
            this.Controls.Add(sendButton);
            
            // 窗体事件
            this.Load += MainForm_Load;
            this.KeyPreview = true;
            this.KeyDown += MainForm_KeyDown;
        }
        
        private void MainForm_Load(object sender, EventArgs e)
        {
            contentTextBox.Focus();
        }
        
        private void MainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Hide();
                e.Handled = true;
            }
        }
        
        private void ContentTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.Return)
            {
                SendMemo();
                e.Handled = true;
            }
        }
        
        private void TagsTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.Return)
            {
                SendMemo();
                e.Handled = true;
            }
        }
        
        private void SendButton_Click(object sender, EventArgs e)
        {
            SendMemo();
        }
        
        private void SendMemo()
        {
            string content = contentTextBox.Text.Trim();
            string tags = tagsTextBox.Text.Trim();
            
            if (string.IsNullOrEmpty(content))
            {
                MessageBox.Show("请输入内容", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                contentTextBox.Focus();
                return;
            }
            
            if (string.IsNullOrEmpty(config.FlomoApiUrl))
            {
                MessageBox.Show(
                    "请先配置Flomo API地址\n\n" +
                    "在系统托盘右键点击图标 → 设置",
                    "提示",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }
            
            // 禁用发送按钮
            sendButton.Enabled = false;
            sendButton.Text = "发送中...";
            
            try
            {
                var api = new FlomoAPI(config.FlomoApiUrl);
                var (success, message) = api.SendMemo(content, tags);
                
                if (success)
                {
                    // 保存使用的标签
                    if (!string.IsNullOrEmpty(tags))
                    {
                        config.LastTags = tags;
                        config.Save();
                    }
                    
                    MessageBox.Show(message, "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    
                    // 清空内容
                    contentTextBox.Clear();
                    
                    // 自动隐藏
                    if (config.AutoHide)
                    {
                        this.Hide();
                    }
                }
                else
                {
                    MessageBox.Show(message, "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"发送失败：{ex.Message}", "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                sendButton.Enabled = true;
                sendButton.Text = "发送 (Ctrl+Enter)";
            }
        }
        
        public void ShowAndFocus()
        {
            this.Show();
            this.Activate();
            this.BringToFront();
            contentTextBox.Focus();
            
            // 加载标签
            if (string.IsNullOrEmpty(tagsTextBox.Text))
            {
                tagsTextBox.Text = config.DefaultTags;
            }
        }
        
        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            // 阻止关闭，改为隐藏
            if (e.CloseReason == CloseReason.UserClosing)
            {
                e.Cancel = true;
                this.Hide();
            }
            base.OnFormClosing(e);
        }
    }
}

