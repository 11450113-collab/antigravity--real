# 使用內建桌面環境的基礎鏡像
FROM lscr.io/linuxserver/webtop:ubuntu-kde

# 設定環境變數
ENV PUID=1000
ENV PGID=1000
ENV TZ=Asia/Taipei

# 1. 安裝基礎工具與準備金鑰目錄
RUN apt-get update && apt-get install -y \
    curl \
    gpg \
    ca-certificates \
    && mkdir -p /etc/apt/keyrings

# 2. 依照官方指南：導入 Google Antigravity 的 GPG 金鑰
RUN curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
    gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg

# 3. 依照官方指南：新增軟體源 (Sources List)
RUN echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
    tee /etc/apt/sources.list.d/antigravity.list > /dev/null

# 4. 更新快取並安裝 antigravity
# 這裡會自動處理你之前遇到的 libasound2 等依賴問題
RUN apt-get update && apt-get install -y \
    antigravity \
    && rm -rf /var/lib/apt/lists/*

# 預設對外端口
EXPOSE 3000