using System;
using System.Drawing;
using System.Windows.Forms;

namespace FlomoQuickNote
{
    /// <summary>
    /// 设置窗口
    /// </summary>
    public partial class SettingsForm : Form
    {
        private ConfigManager config;
        private TextBox apiUrlTextBox;
        private TextBox hotkeyTextBox;
        private TextBox defaultTagsTextBox;
        private CheckBox autoHideCheckBox;
        
        public Action OnSettingsSaved;
        
        public SettingsForm(ConfigManager configManager)
        {
            this.config = configManager;
            InitializeComponent();
        }
        
        private void InitializeComponent()
        {
            // 窗体属性
            this.Text = "设置 - Flomo快速记录";
            this.Size = new Size(520, 550);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.BackColor = Color.White;
            this.Font = new Font("Microsoft YaHei UI", 9F);
            
            int yPos = 20;
            int leftMargin = 30;
            int controlWidth = 440;
            
            // 标题
            var titleLabel = new Label
            {
                Text = "⚙️ 设置",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 30),
                Font = new Font("Microsoft YaHei UI", 14F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(titleLabel);
            yPos += 50;
            
            // ========== ① Flomo API 配置 ==========
            var apiSectionLabel = new Label
            {
                Text = "① Flomo API 配置",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 10F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.FromArgb(240, 240, 240),
                TextAlign = ContentAlignment.MiddleLeft,
                Padding = new Padding(10, 0, 0, 0)
            };
            this.Controls.Add(apiSectionLabel);
            yPos += 35;
            
            var apiLabel = new Label
            {
                Text = "API 地址（必填）",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                Font = new Font("Microsoft YaHei UI", 9F),
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(apiLabel);
            yPos += 25;
            
            apiUrlTextBox = new TextBox
            {
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 9F),
                Text = config.FlomoApiUrl,
                BackColor = Color.White,
                ForeColor = Color.Black
            };
            this.Controls.Add(apiUrlTextBox);
            yPos += 35;
            
            var apiTip = new Label
            {
                Text = "💡 获取方式: flomoapp.com → 头像 → 实验室 → API",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                ForeColor = Color.FromArgb(255, 102, 0),
                Font = new Font("Microsoft YaHei UI", 8F),
                BackColor = Color.Transparent
            };
            this.Controls.Add(apiTip);
            yPos += 30;
            
            var testButton = new Button
            {
                Text = "测试连接",
                Location = new Point(leftMargin, yPos),
                Size = new Size(100, 30),
                BackColor = Color.FromArgb(40, 167, 69),
                ForeColor = Color.White,
                Font = new Font("Microsoft YaHei UI", 9F),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            testButton.FlatAppearance.BorderSize = 0;
            testButton.Click += TestButton_Click;
            this.Controls.Add(testButton);
            yPos += 45;
            
            // ========== ② 全局快捷键设置 ==========
            var hotkeySectionLabel = new Label
            {
                Text = "② 全局快捷键设置",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 10F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.FromArgb(240, 240, 240),
                TextAlign = ContentAlignment.MiddleLeft,
                Padding = new Padding(10, 0, 0, 0)
            };
            this.Controls.Add(hotkeySectionLabel);
            yPos += 35;
            
            var hotkeyLabel = new Label
            {
                Text = "快捷键（用于唤起输入窗口）",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                Font = new Font("Microsoft YaHei UI", 9F),
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(hotkeyLabel);
            yPos += 25;
            
            hotkeyTextBox = new TextBox
            {
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 9F),
                Text = config.Hotkey,
                BackColor = Color.White,
                ForeColor = Color.Black
            };
            this.Controls.Add(hotkeyTextBox);
            yPos += 35;
            
            var hotkeyTip = new Label
            {
                Text = "💡 格式: ctrl+alt+f 或 ctrl+shift+n",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                ForeColor = Color.FromArgb(255, 102, 0),
                Font = new Font("Microsoft YaHei UI", 8F),
                BackColor = Color.Transparent
            };
            this.Controls.Add(hotkeyTip);
            yPos += 35;
            
            // ========== ③ 默认标签设置 ==========
            var tagsSectionLabel = new Label
            {
                Text = "③ 默认标签设置",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 10F, FontStyle.Bold),
                ForeColor = Color.Black,
                BackColor = Color.FromArgb(240, 240, 240),
                TextAlign = ContentAlignment.MiddleLeft,
                Padding = new Padding(10, 0, 0, 0)
            };
            this.Controls.Add(tagsSectionLabel);
            yPos += 35;
            
            var tagsLabel = new Label
            {
                Text = "默认标签（可选）",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                Font = new Font("Microsoft YaHei UI", 9F),
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(tagsLabel);
            yPos += 25;
            
            defaultTagsTextBox = new TextBox
            {
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 9F),
                Text = config.DefaultTags,
                BackColor = Color.White,
                ForeColor = Color.Black
            };
            this.Controls.Add(defaultTagsTextBox);
            yPos += 35;
            
            var tagsTip = new Label
            {
                Text = "💡 多个标签用空格分隔，如: #灵感 #想法",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 20),
                ForeColor = Color.FromArgb(255, 102, 0),
                Font = new Font("Microsoft YaHei UI", 8F),
                BackColor = Color.Transparent
            };
            this.Controls.Add(tagsTip);
            yPos += 35;
            
            // ========== 其他选项 ==========
            autoHideCheckBox = new CheckBox
            {
                Text = "发送成功后自动隐藏输入窗口",
                Location = new Point(leftMargin, yPos),
                Size = new Size(controlWidth, 25),
                Font = new Font("Microsoft YaHei UI", 9F),
                Checked = config.AutoHide,
                ForeColor = Color.Black,
                BackColor = Color.Transparent
            };
            this.Controls.Add(autoHideCheckBox);
            yPos += 45;
            
            // 按钮区域
            var cancelButton = new Button
            {
                Text = "取消",
                Location = new Point(leftMargin + controlWidth - 190, yPos),
                Size = new Size(90, 35),
                BackColor = Color.FromArgb(108, 117, 125),
                ForeColor = Color.White,
                Font = new Font("Microsoft YaHei UI", 10F),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            cancelButton.FlatAppearance.BorderSize = 0;
            cancelButton.Click += (s, e) => this.Close();
            this.Controls.Add(cancelButton);
            
            var saveButton = new Button
            {
                Text = "保存",
                Location = new Point(leftMargin + controlWidth - 90, yPos),
                Size = new Size(90, 35),
                BackColor = Color.FromArgb(0, 123, 255),
                ForeColor = Color.White,
                Font = new Font("Microsoft YaHei UI", 10F, FontStyle.Bold),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            saveButton.FlatAppearance.BorderSize = 0;
            saveButton.Click += SaveButton_Click;
            this.Controls.Add(saveButton);
        }
        
        private void TestButton_Click(object sender, EventArgs e)
        {
            string apiUrl = apiUrlTextBox.Text.Trim();
            
            if (string.IsNullOrEmpty(apiUrl))
            {
                MessageBox.Show("请先输入API地址", "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            
            try
            {
                var api = new FlomoAPI(apiUrl);
                var (success, message) = api.ValidateApiUrl();
                
                if (success)
                {
                    MessageBox.Show(
                        "API连接测试成功！\n\n已自动发送一条测试笔记到你的Flomo",
                        "成功",
                        MessageBoxButtons.OK,
                        MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show($"API连接测试失败\n\n{message}", "失败", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"测试失败：{ex.Message}", "错误", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        
        private void SaveButton_Click(object sender, EventArgs e)
        {
            // 保存配置
            config.FlomoApiUrl = apiUrlTextBox.Text.Trim();
            config.Hotkey = hotkeyTextBox.Text.Trim().ToLower();
            config.DefaultTags = defaultTagsTextBox.Text.Trim();
            config.AutoHide = autoHideCheckBox.Checked;
            
            config.Save();
            
            MessageBox.Show("设置已保存！", "成功", MessageBoxButtons.OK, MessageBoxIcon.Information);
            
            // 触发回调
            OnSettingsSaved?.Invoke();
            
            this.Close();
        }
    }
}

