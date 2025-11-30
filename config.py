"""
配置管理模块
负责加载、保存和管理应用配置
"""
import json
import os
from typing import Dict, Any


class Config:
    """配置管理类"""
    
    DEFAULT_CONFIG = {
        "flomo_api_url": "",  # Flomo API地址
        "hotkey": "ctrl+alt+f",  # 默认快捷键
        "default_tags": "",  # 默认标签，用空格分隔
        "window_width": 500,
        "window_height": 350,
        "auto_hide": True,  # 发送后自动隐藏
        "auto_start": False,  # 开机自启
        "last_tags": "",  # 上次使用的标签
    }
    
    def __init__(self, config_file: str = "config.json"):
        self.config_file = config_file
        self.config: Dict[str, Any] = {}
        self.load()
    
    def load(self) -> None:
        """加载配置文件"""
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r', encoding='utf-8') as f:
                    self.config = json.load(f)
                # 合并默认配置（确保所有键都存在）
                for key, value in self.DEFAULT_CONFIG.items():
                    if key not in self.config:
                        self.config[key] = value
            except Exception as e:
                print(f"加载配置文件失败: {e}")
                self.config = self.DEFAULT_CONFIG.copy()
        else:
            self.config = self.DEFAULT_CONFIG.copy()
            self.save()
    
    def save(self) -> None:
        """保存配置文件"""
        try:
            with open(self.config_file, 'w', encoding='utf-8') as f:
                json.dump(self.config, f, indent=4, ensure_ascii=False)
        except Exception as e:
            print(f"保存配置文件失败: {e}")
    
    def get(self, key: str, default: Any = None) -> Any:
        """获取配置项"""
        return self.config.get(key, default)
    
    def set(self, key: str, value: Any) -> None:
        """设置配置项"""
        self.config[key] = value
        self.save()
    
    def get_all(self) -> Dict[str, Any]:
        """获取所有配置"""
        return self.config.copy()
