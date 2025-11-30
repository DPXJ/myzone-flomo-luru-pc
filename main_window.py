"""
主输入窗口模块
提供快速输入笔记的界面
"""
from PyQt6.QtWidgets import (QWidget, QVBoxLayout, QHBoxLayout, QTextEdit, 
                             QLineEdit, QPushButton, QLabel, QMessageBox)
from PyQt6.QtCore import Qt, pyqtSignal
from PyQt6.QtGui import QFont, QIcon, QKeyEvent
from flomo_api import FlomoAPI
from config import Config


class MainWindow(QWidget):
    """主输入窗口"""
    
    # 定义信号
    hide_window = pyqtSignal()
    
    def __init__(self, config: Config, flomo_api: FlomoAPI):
        super().__init__()
        self.config = config
        self.flomo_api = flomo_api
        self.init_ui()
    
    def init_ui(self):
        """初始化UI"""
        # 窗口属性
        self.setWindowTitle("快速记录到 Flomo")
        self.setWindowFlags(
            Qt.WindowType.WindowStaysOnTopHint |  # 窗口置顶
            Qt.WindowType.FramelessWindowHint |   # 无边框
            Qt.WindowType.Tool                     # 工具窗口（不在任务栏显示）
        )
        
        # 设置窗口大小
        width = self.config.get("window_width", 500)
        height = self.config.get("window_height", 350)
        self.resize(width, height)
        
        # 居中显示
        self.center_on_screen()
        
        # 创建布局
        main_layout = QVBoxLayout()
        main_layout.setContentsMargins(20, 15, 20, 15)
        main_layout.setSpacing(10)
        
        # 标题栏
        title_layout = QHBoxLayout()
        title_label = QLabel("✍️ 快速记录到 Flomo")
        title_label.setFont(QFont("Microsoft YaHei", 11, QFont.Weight.Bold))
        title_layout.addWidget(title_label)
        title_layout.addStretch()
        
        # 关闭按钮
        close_btn = QPushButton("✕")
        close_btn.setFixedSize(30, 30)
        close_btn.setStyleSheet("""
            QPushButton {
                background-color: transparent;
                border: none;
                color: #666;
                font-size: 18px;
            }
            QPushButton:hover {
                background-color: #ff4444;
                color: white;
                border-radius: 15px;
            }
        """)
        close_btn.clicked.connect(self.hide_window_slot)
        title_layout.addWidget(close_btn)
        
        main_layout.addLayout(title_layout)
        
        # 内容输入框
        self.content_edit = QTextEdit()
        self.content_edit.setPlaceholderText("在此输入内容...\n\n💡 按 Ctrl+Enter 快速发送\n💡 按 ESC 关闭窗口")
        self.content_edit.setFont(QFont("Microsoft YaHei", 11))
        self.content_edit.setStyleSheet("""
            QTextEdit {
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                padding: 10px;
                background-color: white;
            }
            QTextEdit:focus {
                border: 2px solid #4a90e2;
            }
        """)
        main_layout.addWidget(self.content_edit)
        
        # 标签输入区域
        tag_layout = QHBoxLayout()
        tag_label = QLabel("🏷️ 标签:")
        tag_label.setFont(QFont("Microsoft YaHei", 10, QFont.Weight.Bold))
        tag_label.setStyleSheet("color: #000000;")
        self.tag_input = QLineEdit()
        self.tag_input.setPlaceholderText("多个标签用空格分隔，如: 灵感 想法")
        self.tag_input.setFont(QFont("Microsoft YaHei", 10))
        self.tag_input.setStyleSheet("""
            QLineEdit {
                border: 1px solid #e0e0e0;
                border-radius: 5px;
                padding: 8px;
                background-color: white;
            }
            QLineEdit:focus {
                border: 2px solid #4a90e2;
            }
        """)
        
        # 加载上次使用的标签
        last_tags = self.config.get("last_tags", "")
        if last_tags:
            self.tag_input.setText(last_tags)
        else:
            default_tags = self.config.get("default_tags", "")
            if default_tags:
                self.tag_input.setText(default_tags)
        
        tag_layout.addWidget(tag_label)
        tag_layout.addWidget(self.tag_input)
        main_layout.addLayout(tag_layout)
        
        # 按钮区域
        button_layout = QHBoxLayout()
        button_layout.addStretch()
        
        # 取消按钮
        cancel_btn = QPushButton("取消 (ESC)")
        cancel_btn.setFixedHeight(35)
        cancel_btn.setStyleSheet("""
            QPushButton {
                background-color: #f5f5f5;
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 0 20px;
                color: #333;
                font-size: 10pt;
            }
            QPushButton:hover {
                background-color: #e8e8e8;
            }
        """)
        cancel_btn.clicked.connect(self.hide_window_slot)
        button_layout.addWidget(cancel_btn)
        
        # 发送按钮
        self.send_btn = QPushButton("发送 (Ctrl+Enter)")
        self.send_btn.setFixedHeight(35)
        self.send_btn.setStyleSheet("""
            QPushButton {
                background-color: #4a90e2;
                border: none;
                border-radius: 5px;
                padding: 0 25px;
                color: white;
                font-size: 10pt;
                font-weight: bold;
            }
            QPushButton:hover {
                background-color: #357abd;
            }
            QPushButton:pressed {
                background-color: #2868a8;
            }
            QPushButton:disabled {
                background-color: #cccccc;
            }
        """)
        self.send_btn.clicked.connect(self.send_memo)
        button_layout.addWidget(self.send_btn)
        
        main_layout.addLayout(button_layout)
        
        # 设置整体样式
        self.setStyleSheet("""
            QWidget {
                background-color: #fafafa;
            }
        """)
        
        self.setLayout(main_layout)
    
    def center_on_screen(self):
        """将窗口居中显示在屏幕上"""
        from PyQt6.QtGui import QScreen
        screen = QScreen.availableGeometry(self.screen())
        x = (screen.width() - self.width()) // 2
        y = (screen.height() - self.height()) // 2
        self.move(x, y)
    
    def keyPressEvent(self, event: QKeyEvent):
        """处理键盘事件"""
        # ESC键关闭窗口
        if event.key() == Qt.Key.Key_Escape:
            self.hide_window_slot()
        
        # Ctrl+Enter发送
        elif event.key() == Qt.Key.Key_Return or event.key() == Qt.Key.Key_Enter:
            if event.modifiers() == Qt.KeyboardModifier.ControlModifier:
                self.send_memo()
        
        else:
            super().keyPressEvent(event)
    
    def show_and_focus(self):
        """显示窗口并获取焦点"""
        self.show()
        self.activateWindow()
        self.raise_()
        self.content_edit.setFocus()
        # 居中显示
        self.center_on_screen()
    
    def hide_window_slot(self):
        """隐藏窗口"""
        self.hide()
        # 清空内容
        self.content_edit.clear()
    
    def send_memo(self):
        """发送笔记到Flomo"""
        content = self.content_edit.toPlainText().strip()
        tags = self.tag_input.text().strip()
        
        if not content:
            msg_box = QMessageBox(self)
            msg_box.setIcon(QMessageBox.Icon.Warning)
            msg_box.setWindowTitle("提示")
            msg_box.setText("请输入内容")
            msg_box.setStyleSheet("""
                QMessageBox { background-color: white; }
                QLabel { color: #000000; font-size: 11pt; min-width: 250px; }
                QPushButton { background-color: #ffc107; color: #000; border: none; 
                             border-radius: 4px; padding: 8px 20px; font-size: 10pt; }
                QPushButton:hover { background-color: #e0a800; }
            """)
            msg_box.exec()
            return
        
        # 检查API配置
        if not self.config.get("flomo_api_url"):
            msg_box = QMessageBox(self)
            msg_box.setIcon(QMessageBox.Icon.Warning)
            msg_box.setWindowTitle("提示")
            msg_box.setText("请先配置Flomo API地址\n\n在系统托盘（右下角）找到应用图标\n右键点击 → 选择「设置」→ 填入API地址")
            msg_box.setStyleSheet("""
                QMessageBox { background-color: white; }
                QLabel { color: #000000; font-size: 11pt; min-width: 350px; }
                QPushButton { background-color: #ffc107; color: #000; border: none; 
                             border-radius: 4px; padding: 8px 20px; font-size: 10pt; }
                QPushButton:hover { background-color: #e0a800; }
            """)
            msg_box.exec()
            return
        
        # 禁用发送按钮
        self.send_btn.setEnabled(False)
        self.send_btn.setText("发送中...")
        
        # 更新API URL
        self.flomo_api.api_url = self.config.get("flomo_api_url")
        
        # 发送到Flomo
        success, message = self.flomo_api.send_memo(content, tags)
        
        # 恢复按钮状态
        self.send_btn.setEnabled(True)
        self.send_btn.setText("发送 (Ctrl+Enter)")
        
        if success:
            # 保存使用的标签
            if tags:
                self.config.set("last_tags", tags)
            
            # 显示成功消息
            msg_box = QMessageBox(self)
            msg_box.setIcon(QMessageBox.Icon.Information)
            msg_box.setWindowTitle("成功")
            msg_box.setText(message)
            msg_box.setStyleSheet("""
                QMessageBox {
                    background-color: white;
                }
                QLabel {
                    color: #000000;
                    font-size: 11pt;
                    min-width: 300px;
                }
                QPushButton {
                    background-color: #4a90e2;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    padding: 8px 20px;
                    font-size: 10pt;
                }
                QPushButton:hover {
                    background-color: #357abd;
                }
            """)
            msg_box.exec()
            
            # 清空内容
            self.content_edit.clear()
            
            # 如果设置了自动隐藏，则隐藏窗口
            if self.config.get("auto_hide", True):
                self.hide()
        else:
            msg_box = QMessageBox(self)
            msg_box.setIcon(QMessageBox.Icon.Critical)
            msg_box.setWindowTitle("错误")
            msg_box.setText(message)
            msg_box.setStyleSheet("""
                QMessageBox {
                    background-color: white;
                }
                QLabel {
                    color: #000000;
                    font-size: 11pt;
                    min-width: 300px;
                }
                QPushButton {
                    background-color: #dc3545;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    padding: 8px 20px;
                    font-size: 10pt;
                }
                QPushButton:hover {
                    background-color: #c82333;
                }
            """)
            msg_box.exec()

