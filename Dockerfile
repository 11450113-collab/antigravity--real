# 使用 LinuxServer 的 Webtop 鏡像，內建瀏覽器存取桌面的功能
FROM lscr.io/linuxserver/webtop:ubuntu-kde

# 設定時區與權限
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Taipei

# 安裝 Antigravity 運行必備的系統套件
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    libnss3 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 從 Google 官網下載並安裝 Antigravity 
# 注意：此處需更換為當前版本的最新的下載鏈接
RUN curl -L "https://antigravity.google/download/linux/main.deb" -o antigravity.deb && \
    apt-get install -y ./antigravity.deb && \
    rm antigravity.deb

# Render 預設對外端口，Webtop 默認為 3000
EXPOSE 3000

# 啟動命令已由基礎鏡像處理，Antigravity 會在啟動後在桌面中打開