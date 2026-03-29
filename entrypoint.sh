#!/bin/bash

# 啟動虛擬桌面
Xvfb :1 -screen 0 1280x720x24 &

# 啟動 Chrome 指向 antigravity.google
google-chrome --no-sandbox --disable-gpu --display=:1 https://antigravity.google/ &

# 啟動 x11vnc + noVNC
x11vnc -display :1 -nopw -forever -shared &
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# 保持容器活著
tail -f /dev/null
