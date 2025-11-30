"""
全局热键管理模块
负责注册和监听全局快捷键
"""
import keyboard
from typing import Callable, Optional, Tuple


class HotkeyManager:
    """全局热键管理器"""
    
    def __init__(self):
        self.current_hotkey: Optional[str] = None
        self.callback: Optional[Callable] = None
    
    def register(self, hotkey: str, callback: Callable) -> Tuple[bool, str]:
        """
        注册全局热键
        :param hotkey: 快捷键字符串，如 'ctrl+alt+f'
        :param callback: 触发时的回调函数
        :return: (是否成功, 消息)
        """
        try:
            # 先注销之前的热键
            if self.current_hotkey:
                self.unregister()
            
            # 注册新热键
            keyboard.add_hotkey(hotkey, callback)
            self.current_hotkey = hotkey
            self.callback = callback
            
            return True, f"快捷键 {hotkey} 注册成功"
            
        except Exception as e:
            return False, f"注册快捷键失败: {str(e)}"
    
    def unregister(self) -> None:
        """注销当前热键"""
        if self.current_hotkey:
            try:
                keyboard.remove_hotkey(self.current_hotkey)
            except:
                pass
            self.current_hotkey = None
            self.callback = None
    
    def is_registered(self) -> bool:
        """检查是否已注册热键"""
        return self.current_hotkey is not None
    
    @staticmethod
    def is_valid_hotkey(hotkey: str) -> bool:
        """
        验证快捷键格式是否有效
        :param hotkey: 快捷键字符串
        :return: 是否有效
        """
        try:
            # 简单验证：检查是否包含修饰键
            hotkey_lower = hotkey.lower()
            modifiers = ['ctrl', 'alt', 'shift', 'win']
            has_modifier = any(mod in hotkey_lower for mod in modifiers)
            
            # 检查是否有按键
            has_key = '+' in hotkey and len(hotkey.split('+')) >= 2
            
            return has_modifier and has_key
        except:
            return False
