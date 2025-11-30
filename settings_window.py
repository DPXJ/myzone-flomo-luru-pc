"""
设置窗口模块
提供应用配置界面
"""
from PyQt6.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QLabel, 
                             QLineEdit, QPushButton, QCheckBox, QGroupBox,
                             QMessageBox)
from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QFont, QPalette, QColor
from config import Config
from flomo_api import FlomoAPI
from hotkey_manager import HotkeyManager


class SettingsWindow(QWidget):
    """设置窗口"""
    
    # 定义信号
    hotkey_changed = pyqtSignal(str)  # 快捷键变更信号
    
    def __init__(self, config: Config):
        super().__init__()
        self.config = config
        self.init_ui()
    
    def init_ui(self):
        """初始化UI"""
        self.setWindowTitle("设置 - Flomo快速记录")
        self.resize(650, 700)
        
        # 设置窗口背景色
        palette = self.palette()
        palette.setColor(QPalette.ColorRole.Window, QColor(245, 245, 245))
        self.setPalette(palette)
        self.setAutoFillBackground(True)
        
        # 居中显示
        self.center_on_screen()
        
        # 主布局
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(25, 25, 25, 25)
        main_layout.setSpacing(20)
        
        # 标题
        title = QLabel("⚙️ 设置")
        title.setFont(QFont("Microsoft YaHei", 16, QFont.Weight.Bold))
        title.setStyleSheet("color: #000000; background: transparent;")
        main_layout.addWidget(title)
        
        # ========== ① Flomo API 配置 ==========
        api_group = self.create_group_box("① Flomo API 配置")
        api_layout = QVBoxLayout()
        api_layout.setSpacing(10)
        
        # API标签
        api_label = QLabel("📌 API地址（必填）")
        api_label.setFont(QFont("Microsoft YaHei", 10, QFont.Weight.Bold))
        api_label.setStyleSheet("color: #000000; background: transparent;")
        api_layout.addWidget(api_label)
        
        # API输入框
        self.api_url_input = QLineEdit()
        self.api_url_input.setPlaceholderText("粘贴你的Flomo API地址，如: https://flomoapp.com/iwh/xxxxx")
        self.api_url_input.setText(self.config.get("flomo_api_url", ""))
        self.api_url_input.setMinimumHeight(45)
        self.api_url_input.setFont(QFont("Microsoft YaHei", 10))
        self.api_url_input.setStyleSheet("""
            QLineEdit {
                padding: 12px;
                border: 2px solid #cccccc;
                border-radius: 6px;
                background-color: #ffffff;
                color: #000000;
            }
            QLineEdit:focus {
                border: 2px solid #4a90e2;
            }
        """)
        api_layout.addWidget(self.api_url_input)
        
        # API提示
        api_tip = QLabel("💡 获取方法: 登录 flomoapp.com → 头像 → 设置 → API → 复制")
        api_tip.setFont(QFont("Microsoft YaHei", 9))
        api_tip.setStyleSheet("color: #FF6600; background: transparent;")
        api_tip.setWordWrap(True)
        api_layout.addWidget(api_tip)
        
        # 测试按钮
        test_btn = QPushButton("🔌 测试连接")
        test_btn.setMinimumHeight(38)
        test_btn.setFont(QFont("Microsoft YaHei", 10, QFont.Weight.Bold))
        test_btn.setStyleSheet("""
            QPushButton {
                background-color: #28a745;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 20px;
            }
            QPushButton:hover {
                background-color: #218838;
            }
            QPushButton:pressed {
                background-color: #1e7e34;
            }
        """)
        test_btn.clicked.connect(self.test_api_connection)
        api_layout.addWidget(test_btn)
        
        api_group.setLayout(api_layout)
        main_layout.addWidget(api_group)
        
        # ========== ② 全局快捷键设置 ==========
        hotkey_group = self.create_group_box("② 全局快捷键设置")
        hotkey_layout = QVBoxLayout()
        hotkey_layout.setSpacing(10)
        
        # 快捷键标签
        hotkey_label = QLabel("⌨️ 快捷键（用于唤起输入窗口）")
        hotkey_label.setFont(QFont("Microsoft YaHei", 10, QFont.Weight.Bold))
        hotkey_label.setStyleSheet("color: #000000; background: transparent;")
        hotkey_layout.addWidget(hotkey_label)
        
        # 快捷键输入
        self.hotkey_input = QLineEdit()
        self.hotkey_input.setPlaceholderText("如: ctrl+alt+f")
        self.hotkey_input.setText(self.config.get("hotkey", "ctrl+alt+f"))
        self.hotkey_input.setMinimumHeight(45)
        self.hotkey_input.setFont(QFont("Microsoft YaHei", 10))
        self.hotkey_input.setStyleSheet("""
            QLineEdit {
                padding: 12px;
                border: 2px solid #cccccc;
                border-radius: 6px;
                background-color: #ffffff;
                color: #000000;
            }
            QLineEdit:focus {
                border: 2px solid #4a90e2;
            }
        """)
        hotkey_layout.addWidget(self.hotkey_input)
        
        # 快捷键提示
        hotkey_tip = QLabel("💡 格式: 修饰键+按键，如 ctrl+alt+f")
        hotkey_tip.setFont(QFont("Microsoft YaHei", 9))
        hotkey_tip.setStyleSheet("color: #FF6600; background: transparent;")
        hotkey_layout.addWidget(hotkey_tip)
        
        hotkey_group.setLayout(hotkey_layout)
        main_layout.addWidget(hotkey_group)
        
        # ========== ③ 默认标签设置 ==========
        tags_group = self.create_group_box("③ 默认标签设置")
        tags_layout = QVBoxLayout()
        tags_layout.setSpacing(10)
        
        # 标签标签
        tags_label = QLabel("🏷️ 默认标签（可选，自动填充）")
        tags_label.setFont(QFont("Microsoft YaHei", 10, QFont.Weight.Bold))
        tags_label.setStyleSheet("color: #000000; background: transparent;")
        tags_layout.addWidget(tags_label)
        
        # 标签输入
        self.default_tags_input = QLineEdit()
        self.default_tags_input.setPlaceholderText("如: 灵感 想法 工作")
        self.default_tags_input.setText(self.config.get("default_tags", ""))
        self.default_tags_input.setMinimumHeight(45)
        self.default_tags_input.setFont(QFont("Microsoft YaHei", 10))
        self.default_tags_input.setStyleSheet("""
            QLineEdit {
                padding: 12px;
                border: 2px solid #cccccc;
                border-radius: 6px;
                background-color: #ffffff;
                color: #000000;
            }
            QLineEdit:focus {
                border: 2px solid #4a90e2;
            }
        """)
        tags_layout.addWidget(self.default_tags_input)
        
        # 标签提示
        tags_tip = QLabel("💡 多个标签用空格分隔，无需添加#号")
        tags_tip.setFont(QFont("Microsoft YaHei", 9))
        tags_tip.setStyleSheet("color: #FF6600; background: transparent;")
        tags_layout.addWidget(tags_tip)
        
        tags_group.setLayout(tags_layout)
        main_layout.addWidget(tags_group)
        
        # ========== ④ 其他选项 ==========
        options_group = self.create_group_box("④ 其他选项")
        options_layout = QVBoxLayout()
        options_layout.setSpacing(10)
        
        self.auto_hide_checkbox = QCheckBox("✅ 发送成功后自动隐藏输入窗口")
        self.auto_hide_checkbox.setFont(QFont("Microsoft YaHei", 10))
        self.auto_hide_checkbox.setStyleSheet("""
            QCheckBox {
                color: #000000;
                background: transparent;
                spacing: 10px;
            }
            QCheckBox::indicator {
                width: 22px;
                height: 22px;
            }
        """)
        self.auto_hide_checkbox.setChecked(self.config.get("auto_hide", True))
        options_layout.addWidget(self.auto_hide_checkbox)
        
        options_group.setLayout(options_layout)
        main_layout.addWidget(options_group)
        
        # 添加弹簧
        main_layout.addStretch()
        
        # ========== 按钮区域 ==========
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        # 取消按钮
        cancel_btn = QPushButton("取消")
        cancel_btn.setMinimumSize(110, 40)
        cancel_btn.setFont(QFont("Microsoft YaHei", 11, QFont.Weight.Bold))
        cancel_btn.setStyleSheet("""
            QPushButton {
                background-color: #6c757d;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 25px;
            }
            QPushButton:hover {
                background-color: #5a6268;
            }
            QPushButton:pressed {
                background-color: #4e555b;
            }
        """)
        cancel_btn.clicked.connect(self.close)
        button_layout.addWidget(cancel_btn)
        
        # 保存按钮
        save_btn = QPushButton("保存")
        save_btn.setMinimumSize(110, 40)
        save_btn.setFont(QFont("Microsoft YaHei", 11, QFont.Weight.Bold))
        save_btn.setStyleSheet("""
            QPushButton {
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 10px 25px;
            }
            QPushButton:hover {
                background-color: #0056b3;
            }
            QPushButton:pressed {
                background-color: #004085;
            }
        """)
        save_btn.clicked.connect(self.save_settings)
        button_layout.addWidget(save_btn)
        
        main_layout.addLayout(button_layout)
        
        self.setLayout(main_layout)
    
    def create_group_box(self, title):
        """创建统一样式的分组框"""
        group_box = QGroupBox(title)
        group_box.setFont(QFont("Microsoft YaHei", 11, QFont.Weight.Bold))
        group_box.setStyleSheet("""
            QGroupBox {
                background-color: white;
                border: 2px solid #dedede;
                border-radius: 10px;
                margin-top: 12px;
                padding: 20px 15px 15px 15px;
                color: #000000;
            }
            QGroupBox::title {
                subcontrol-origin: margin;
                subcontrol-position: top left;
                left: 20px;
                top: 8px;
                padding: 0 10px;
                background-color: white;
                color: #000000;
            }
        """)
        return group_box
    
    def center_on_screen(self):
        """将窗口居中显示"""
        from PyQt6.QtGui import QScreen
        screen = QScreen.availableGeometry(self.screen())
        x = (screen.width() - self.width()) // 2
        y = (screen.height() - self.height()) // 2
        self.move(x, y)
    
    def test_api_connection(self):
        """测试API连接"""
        api_url = self.api_url_input.text().strip()
        
        if not api_url:
            self.show_message("提示", "请先输入API地址", QMessageBox.Icon.Warning)
            return
        
        # 创建临时API对象测试
        flomo_api = FlomoAPI(api_url)
        success, message = flomo_api.validate_api_url()
        
        if success:
            self.show_message("成功", "API连接测试成功！\n\n已自动发送一条测试笔记到你的Flomo", QMessageBox.Icon.Information)
        else:
            self.show_message("失败", f"API连接测试失败\n\n{message}", QMessageBox.Icon.Critical)
    
    def save_settings(self):
        """保存设置"""
        # 获取输入值
        api_url = self.api_url_input.text().strip()
        hotkey = self.hotkey_input.text().strip().lower()
        default_tags = self.default_tags_input.text().strip()
        auto_hide = self.auto_hide_checkbox.isChecked()
        
        # 验证快捷键格式
        if hotkey and not HotkeyManager.is_valid_hotkey(hotkey):
            self.show_message("提示", "快捷键格式不正确\n\n请使用格式：ctrl+alt+f", QMessageBox.Icon.Warning)
            return
        
        # 检查快捷键是否变更
        old_hotkey = self.config.get("hotkey")
        hotkey_changed = (hotkey != old_hotkey)
        
        # 保存配置
        self.config.set("flomo_api_url", api_url)
        self.config.set("hotkey", hotkey)
        self.config.set("default_tags", default_tags)
        self.config.set("auto_hide", auto_hide)
        
        # 如果快捷键变更，发送信号
        if hotkey_changed and hotkey:
            self.hotkey_changed.emit(hotkey)
        
        self.show_message("成功", "设置已保存！", QMessageBox.Icon.Information)
        self.close()
    
    def show_message(self, title, text, icon):
        """显示消息框"""
        msg_box = QMessageBox(self)
        msg_box.setIcon(icon)
        msg_box.setWindowTitle(title)
        msg_box.setText(text)
        msg_box.setStyleSheet("""
            QMessageBox {
                background-color: white;
            }
            QLabel {
                color: #000000;
                font-size: 11pt;
                min-width: 350px;
                background: transparent;
            }
            QPushButton {
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                padding: 8px 20px;
                font-size: 10pt;
                min-width: 80px;
            }
            QPushButton:hover {
                background-color: #0056b3;
            }
        """)
        msg_box.exec()
