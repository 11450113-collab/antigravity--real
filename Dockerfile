FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Taipei \
    PORT=3000

# 安裝最小依賴 + antigravity + python (提供假 server)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gpg \
        python3 && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
        gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
        > /etc/apt/sources.list.d/antigravity.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends antigravity && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 建立非 root 使用者
RUN useradd -m appuser
USER appuser
WORKDIR /home/appuser

# 🔥 核心：背景跑 + 假 server 保活
CMD sh -c "antigravity & python3 -m http.server $PORT"
