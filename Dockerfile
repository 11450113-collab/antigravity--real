FROM lscr.io/linuxserver/webtop:ubuntu-kde

ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Taipei

# 安裝 + antigravity + 清理 + 精簡 KDE
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

    # 🔥 移除肥大套件（KDE 常見重物）
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
        plasma-discover \
        && \

    # 🔥 自動移除殘留依賴
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3000
