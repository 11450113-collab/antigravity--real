FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Taipei \
    PORT=6080

# 安裝必要套件
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl python3 python3-pip \
    xvfb x11vnc novnc websockify \
    ca-certificates fonts-liberation libnss3 libxss1 libasound2 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libgtk-3-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安裝 Google Chrome
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y /tmp/chrome.deb \
    && rm /tmp/chrome.deb

# 建立非 root 使用者
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

# 複製 entrypoint
COPY entrypoint.sh /home/appuser/entrypoint.sh
RUN chmod +x /home/appuser/entrypoint.sh

EXPOSE 6080
CMD ["/home/appuser/entrypoint.sh"]
