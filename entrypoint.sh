#!/bin/bash
set -e

# 使用 Xvfb 啟動 headless Chrome，打開 antigravity 網頁
Xvfb :99 -screen 0 1280x720x24 &
export DISPLAY=:99

# 啟動 Chrome
google-chrome --headless --disable-gpu --remote-debugging-port=9222 https://antigravity.google/ &
wait
