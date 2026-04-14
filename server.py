#!/usr/bin/env python3
"""
简单HTTP服务器，用于托管字母学习游戏
"""

import http.server
import socketserver
import os
from functools import partial

# 设置端口
PORT = 8000

# 设置根目录为当前目录
WEB_ROOT = os.path.dirname(os.path.abspath(__file__))

class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_ROOT, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        super().end_headers()

Handler = partial(CORSRequestHandler)

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"字母学习游戏服务器正在运行在端口 {PORT}")
    print(f"请在浏览器中访问 http://localhost:{PORT} 或者服务器的IP地址:{PORT}")
    print("按 Ctrl+C 停止服务器")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n服务器已停止")