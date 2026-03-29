FROM lscr.io/linuxserver/webtop:ubuntu-kde

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Taipei

# 安裝 + antigravity + 精簡
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gpg \
        ca-certificates && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
        > /etc/apt/sources.list.d/antigravity.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends antigravity && \

    # 🔥 移除肥大套件
    apt-get purge -y \
        libreoffice* \
        thunderbird \
        firefox* \
        vlc \
        games-* \
        kdeconnect \
        khelpcenter \
        kmahjongg \
        kmines \
        kpat \
        plasma-discover && \

    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 🔥 建立 log 目錄
RUN mkdir -p /var/log/antigravity

# 🔥 啟動腳本（自動啟動 + log + 檢查）
RUN echo '#!/bin/bash\n\
echo "[INFO] Container start: $(date)" >> /var/log/antigravity/start.log\n\
\n\
# 檢查 antigravity 是否存在\n\
if ! command -v antigravity >/dev/null 2>&1; then\n\
  echo "[ERROR] antigravity not found!" >> /var/log/antigravity/error.log\n\
  exit 1\n\
fi\n\
\n\
# 啟動 antigravity（背景）\n\
antigravity >> /var/log/antigravity/app.log 2>&1 &\n\
\n\
# 顯示進程\n\
echo "[INFO] Running processes:" >> /var/log/antigravity/start.log\n\
ps aux >> /var/log/antigravity/start.log\n\
\n\
# 啟動原本 webtop\n\
exec /init\n' > /start.sh && chmod +x /start.sh

# 🔥 健康檢查（確認程式還活著）
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD pgrep antigravity || exit 1

# 🔥 使用自訂啟動
CMD ["/start.sh"]

EXPOSE 3000
