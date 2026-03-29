# 使用最小 Ubuntu 22.04
FROM ubuntu:22.04

# 設定時區
ENV TZ=Asia/Taipei
ENV DEBIAN_FRONTEND=noninteractive

# 建立非 root 用戶
RUN useradd -m appuser

# 安裝必要套件（最小化 headless Chrome 環境）
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl python3 python3-pip \
    xvfb \
    ca-certificates fonts-liberation \
    libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 libgtk-3-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安裝 Google Chrome
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb

# 複製 entrypoint
COPY entrypoint.sh /home/appuser/entrypoint.sh
RUN chmod +x /home/appuser/entrypoint.sh

# 切換到非 root 用戶
USER appuser
WORKDIR /home/appuser

# 對外端口 (如果要用 web 瀏覽器看)
EXPOSE 3000

# 啟動腳本
ENTRYPOINT ["./entrypoint.sh"]
