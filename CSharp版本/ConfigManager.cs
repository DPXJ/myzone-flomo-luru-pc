using System;
using System.IO;
using Newtonsoft.Json;

namespace FlomoQuickNote
{
    /// <summary>
    /// 配置管理类
    /// </summary>
    public class ConfigManager
    {
        private const string CONFIG_FILE = "config.json";
        
        public string FlomoApiUrl { get; set; } = "";
        public string Hotkey { get; set; } = "ctrl+alt+f";
        public string DefaultTags { get; set; } = "";
        public string LastTags { get; set; } = "";
        public bool AutoHide { get; set; } = true;
        
        public ConfigManager()
        {
            Load();
        }
        
        public void Load()
        {
            try
            {
                if (File.Exists(CONFIG_FILE))
                {
                    string json = File.ReadAllText(CONFIG_FILE);
                    var config = JsonConvert.DeserializeObject<ConfigManager>(json);
                    
                    if (config != null)
                    {
                        FlomoApiUrl = config.FlomoApiUrl ?? "";
                        Hotkey = config.Hotkey ?? "ctrl+alt+f";
                        DefaultTags = config.DefaultTags ?? "";
                        LastTags = config.LastTags ?? "";
                        AutoHide = config.AutoHide;
                    }
                }
                else
                {
                    // 首次运行，保存默认配置
                    Save();
                }
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(
                    $"加载配置文件失败：{ex.Message}",
                    "错误",
                    System.Windows.Forms.MessageBoxButtons.OK,
                    System.Windows.Forms.MessageBoxIcon.Error);
            }
        }
        
        public void Save()
        {
            try
            {
                string json = JsonConvert.SerializeObject(this, Formatting.Indented);
                File.WriteAllText(CONFIG_FILE, json);
            }
            catch (Exception ex)
            {
                System.Windows.Forms.MessageBox.Show(
                    $"保存配置文件失败：{ex.Message}",
                    "错误",
                    System.Windows.Forms.MessageBoxButtons.OK,
                    System.Windows.Forms.MessageBoxIcon.Error);
            }
        }
    }
}

