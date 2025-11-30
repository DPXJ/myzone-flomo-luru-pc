using System;
using System.Net.Http;
using System.Text;
using Newtonsoft.Json;

namespace FlomoQuickNote
{
    /// <summary>
    /// Flomo API封装类
    /// </summary>
    public class FlomoAPI
    {
        private readonly string apiUrl;
        private readonly HttpClient httpClient;
        
        public FlomoAPI(string url)
        {
            this.apiUrl = url;
            this.httpClient = new HttpClient();
            this.httpClient.Timeout = TimeSpan.FromSeconds(10);
        }
        
        /// <summary>
        /// 发送笔记到Flomo
        /// </summary>
        public (bool success, string message) SendMemo(string content, string tags = "")
        {
            if (string.IsNullOrWhiteSpace(apiUrl))
            {
                return (false, "请先配置Flomo API地址");
            }
            
            if (string.IsNullOrWhiteSpace(content))
            {
                return (false, "内容不能为空");
            }
            
            try
            {
                // 格式化内容，添加标签
                string fullContent = content.Trim();
                
                if (!string.IsNullOrWhiteSpace(tags))
                {
                    var tagList = tags.Trim().Split(' ', StringSplitOptions.RemoveEmptyEntries);
                    foreach (var tag in tagList)
                    {
                        string formattedTag = tag.StartsWith("#") ? tag : "#" + tag;
                        fullContent += " " + formattedTag;
                    }
                }
                
                // 构建请求
                var requestData = new { content = fullContent };
                var jsonContent = JsonConvert.SerializeObject(requestData);
                var httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");
                
                // 发送请求
                var response = httpClient.PostAsync(apiUrl, httpContent).Result;
                
                if (response.IsSuccessStatusCode)
                {
                    return (true, "发送成功！");
                }
                else
                {
                    return (false, $"发送失败: HTTP {(int)response.StatusCode}");
                }
            }
            catch (HttpRequestException ex)
            {
                return (false, $"网络错误: {ex.Message}");
            }
            catch (Exception ex)
            {
                return (false, $"发送失败: {ex.Message}");
            }
        }
        
        /// <summary>
        /// 验证API地址是否有效
        /// </summary>
        public (bool success, string message) ValidateApiUrl()
        {
            if (string.IsNullOrWhiteSpace(apiUrl))
            {
                return (false, "API地址为空");
            }
            
            if (!apiUrl.StartsWith("http"))
            {
                return (false, "API地址格式不正确");
            }
            
            try
            {
                // 发送测试请求
                var requestData = new { content = "测试连接 - Flomo快速记录" };
                var jsonContent = JsonConvert.SerializeObject(requestData);
                var httpContent = new StringContent(jsonContent, Encoding.UTF8, "application/json");
                
                var response = httpClient.PostAsync(apiUrl, httpContent).Result;
                
                if (response.IsSuccessStatusCode)
                {
                    return (true, "API地址有效");
                }
                else
                {
                    return (false, $"API地址无效: HTTP {(int)response.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                return (false, $"验证失败: {ex.Message}");
            }
        }
    }
}

