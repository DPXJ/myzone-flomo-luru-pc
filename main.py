"""
Flomo快速记录 - 主程序入口
通过全局快捷键快速记录笔记到Flomo
"""
import sys
import os
from PyQt6.QtWidgets import QApplication, QSystemTrayIcon, QMenu
from PyQt6.QtGui import QIcon, QAction
from PyQt6.QtCore import QObject, pyqtSignal
from config import Config
from flomo_api import FlomoAPI
from hotkey_manager import HotkeyManager
from main_window import MainWindow
from settings_window import SettingsWindow


class FlomoQuickNote(QObject):
    """主应用类"""
    
    def __init__(self):
        super().__init__()
        
        # 初始化配置
        self.config = Config()
        
        # 初始化Flomo API
        api_url = self.config.get("flomo_api_url", "")
        self.flomo_api = FlomoAPI(api_url)
        
        # 初始化热键管理器
        self.hotkey_manager = HotkeyManager()
        
        # 初始化主窗口
        self.main_window = MainWindow(self.config, self.flomo_api)
        
        # 初始化设置窗口
        self.settings_window = SettingsWindow(self.config)
        self.settings_window.hotkey_changed.connect(self.on_hotkey_changed)
        
        # 初始化系统托盘
        self.init_tray_icon()
        
        # 注册全局快捷键
        self.register_hotkey()
        
        print("Flomo快速记录已启动！")
        print(f"当前快捷键: {self.config.get('hotkey', 'ctrl+alt+f')}")
    
    def init_tray_icon(self):
        """初始化系统托盘图标"""
        # 创建托盘图标（暂时使用系统默认图标）
        self.tray_icon = QSystemTrayIcon()
        
        # 尝试加载图标文件，如果不存在则使用默认图标
        icon_path = "resources/icon.ico"
        if os.path.exists(icon_path):
            self.tray_icon.setIcon(QIcon(icon_path))
        else:
            # 使用Qt内置的信息图标作为默认图标
            from PyQt6.QtWidgets import QStyle
            app = QApplication.instance()
            icon = app.style().standardIcon(QStyle.StandardPixmap.SP_MessageBoxInformation)
            self.tray_icon.setIcon(icon)
        
        self.tray_icon.setToolTip("Flomo快速记录")
        
        # 创建托盘菜单
        tray_menu = QMenu()
        
        # 打开输入窗口
        open_action = QAction("📝 打开输入窗口", self)
        hotkey_text = self.config.get("hotkey", "ctrl+alt+f").upper()
        open_action.setText(f"📝 打开输入窗口 ({hotkey_text})")
        open_action.triggered.connect(self.show_main_window)
        tray_menu.addAction(open_action)
        
        tray_menu.addSeparator()
        
        # 设置
        settings_action = QAction("⚙️ 设置", self)
        settings_action.triggered.connect(self.show_settings)
        tray_menu.addAction(settings_action)
        
        # 关于
        about_action = QAction("ℹ️ 关于", self)
        about_action.triggered.connect(self.show_about)
        tray_menu.addAction(about_action)
        
        tray_menu.addSeparator()
        
        # 退出
        quit_action = QAction("🚪 退出", self)
        quit_action.triggered.connect(self.quit_app)
        tray_menu.addAction(quit_action)
        
        self.tray_icon.setContextMenu(tray_menu)
        
        # 双击托盘图标打开输入窗口
        self.tray_icon.activated.connect(self.on_tray_icon_activated)
        
        # 显示托盘图标
        self.tray_icon.show()
    
    def on_tray_icon_activated(self, reason):
        """托盘图标被点击"""
        if reason == QSystemTrayIcon.ActivationReason.DoubleClick:
            self.show_main_window()
    
    def register_hotkey(self):
        """注册全局快捷键"""
        hotkey = self.config.get("hotkey", "ctrl+alt+f")
        success, message = self.hotkey_manager.register(hotkey, self.on_hotkey_pressed)
        
        if success:
            print(message)
        else:
            print(f"警告: {message}")
            self.tray_icon.showMessage(
                "快捷键注册失败",
                f"{message}\n请在设置中更换快捷键",
                QSystemTrayIcon.MessageIcon.Warning,
                3000
            )
    
    def on_hotkey_pressed(self):
        """快捷键被按下"""
        print("快捷键被触发！")
        self.show_main_window()
    
    def on_hotkey_changed(self, new_hotkey: str):
        """快捷键变更时重新注册"""
        print(f"快捷键已更改为: {new_hotkey}")
        self.register_hotkey()
    
    def show_main_window(self):
        """显示主输入窗口"""
        self.main_window.show_and_focus()
    
    def show_settings(self):
        """显示设置窗口"""
        self.settings_window.show()
        self.settings_window.activateWindow()
        self.settings_window.raise_()
    
    def show_about(self):
        """显示关于对话框"""
        from PyQt6.QtWidgets import QMessageBox
        QMessageBox.about(
            None,
            "关于 Flomo快速记录",
            "<h3>Flomo快速记录</h3>"
            "<p>版本: 1.0.0</p>"
            "<p>一个帮助你快速记录灵感到Flomo的桌面应用</p>"
            "<p><b>功能特性:</b></p>"
            "<ul>"
            "<li>✅ 全局快捷键快速唤起</li>"
            "<li>✅ 支持标签管理</li>"
            "<li>✅ 系统托盘常驻</li>"
            "<li>✅ 轻量级设计</li>"
            "</ul>"
            "<p style='color:#666;'>基于 Python + PyQt6 开发</p>"
        )
    
    def quit_app(self):
        """退出应用"""
        # 注销热键
        self.hotkey_manager.unregister()
        
        # 隐藏托盘图标
        self.tray_icon.hide()
        
        # 退出应用
        QApplication.quit()


def main():
    """主函数"""
    # 创建应用实例
    app = QApplication(sys.argv)
    
    # 设置应用信息
    app.setApplicationName("Flomo快速记录")
    app.setOrganizationName("FlomoQuickNote")
    
    # 设置应用不在关闭最后一个窗口时退出
    app.setQuitOnLastWindowClosed(False)
    
    # 创建主应用对象
    flomo_app = FlomoQuickNote()
    
    # 显示启动消息
    flomo_app.tray_icon.showMessage(
        "Flomo快速记录",
        f"已启动！按 {flomo_app.config.get('hotkey', 'ctrl+alt+f').upper()} 快速记录",
        QSystemTrayIcon.MessageIcon.Information,
        3000
    )
    
    # 运行应用
    sys.exit(app.exec())


if __name__ == "__main__":
    main()

