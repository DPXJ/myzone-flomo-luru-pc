"""
Flomo API模块
负责与Flomo服务进行交互
"""
import requests
from typing import Optional, Tuple


class FlomoAPI:
    """Flomo API封装类"""
    
    def __init__(self, api_url: str):
        """
        初始化Flomo API
        :param api_url: Flomo API地址（从flomo设置中获取）
        """
        self.api_url = api_url
        self.timeout = 10  # 请求超时时间
    
    def send_memo(self, content: str, tags: str = "") -> Tuple[bool, str]:
        """
        发送笔记到Flomo
        :param content: 笔记内容
        :param tags: 标签，多个标签用空格分隔
        :return: (是否成功, 消息)
        """
        if not self.api_url:
            return False, "请先在设置中配置Flomo API地址"
        
        if not content.strip():
            return False, "内容不能为空"
        
        # 格式化内容，添加标签
        full_content = content.strip()
        if tags.strip():
            # 确保标签以#开头
            tag_list = tags.strip().split()
            formatted_tags = []
            for tag in tag_list:
                if tag and not tag.startswith('#'):
                    formatted_tags.append(f'#{tag}')
                elif tag:
                    formatted_tags.append(tag)
            
            if formatted_tags:
                full_content += " " + " ".join(formatted_tags)
        
        try:
            # 发送POST请求
            response = requests.post(
                self.api_url,
                json={"content": full_content},
                headers={"Content-Type": "application/json"},
                timeout=self.timeout
            )
            
            if response.status_code == 200:
                return True, "发送成功！"
            else:
                return False, f"发送失败: HTTP {response.status_code}"
                
        except requests.exceptions.Timeout:
            return False, "请求超时，请检查网络连接"
        except requests.exceptions.ConnectionError:
            return False, "网络连接失败，请检查网络"
        except Exception as e:
            return False, f"发送失败: {str(e)}"
    
    def validate_api_url(self) -> Tuple[bool, str]:
        """
        验证API地址是否有效
        :return: (是否有效, 消息)
        """
        if not self.api_url:
            return False, "API地址为空"
        
        if not self.api_url.startswith("http"):
            return False, "API地址格式不正确"
        
        try:
            # 发送测试请求
            response = requests.post(
                self.api_url,
                json={"content": "测试连接"},
                headers={"Content-Type": "application/json"},
                timeout=5
            )
            
            if response.status_code == 200:
                return True, "API地址有效"
            else:
                return False, f"API地址无效: HTTP {response.status_code}"
                
        except Exception as e:
            return False, f"验证失败: {str(e)}"
