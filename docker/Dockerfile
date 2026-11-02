FROM ubuntu:24.04

ARG ORCA_VERSION=v1.4.246

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    HOME=/home/orca

# Install dependencies for Electron, Xvfb, Git, and common development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
    sudo \
    procps \
    jq \
    dbus-x11 \
    xauth \
    xvfb \
    libasound2t64 \
    libatk-bridge2.0-0 \
    libatspi2.0-0 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libxss1 \
    python3 \
    build-essential \
  && rm -rf /var/lib/apt/lists/*

# Install modern Node.js inside container for terminal usage
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y nodejs \
  && corepack enable \
  && rm -rf /var/lib/apt/lists/*

# Download and extract Orca AppImage
RUN mkdir -p /opt/orca \
  && curl -fsSL -o /tmp/orca-linux.AppImage "https://github.com/stablyai/orca/releases/download/${ORCA_VERSION}/orca-linux.AppImage" \
  && chmod +x /tmp/orca-linux.AppImage \
  && cd /tmp && ./orca-linux.AppImage --appimage-extract \
  && mv /tmp/squashfs-root/* /opt/orca/ \
  && rm -rf /tmp/orca-linux.AppImage /tmp/squashfs-root

# Setup unprivileged user with sudo access
RUN (id -u 1000 >/dev/null 2>&1 && userdel -r $(id -un 1000) || true) \
  && useradd -m -s /bin/bash -u 1000 orca \
  && echo "orca ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir -p /workspace /home/orca/.config/orca /home/orca/.local/share/orca \
  && chown -R orca:orca /workspace /home/orca

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace
EXPOSE 6768

VOLUME ["/home/orca/.config/orca", "/home/orca/.local/share/orca", "/workspace"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
