# syntax=docker/dockerfile:1
FROM debian:12-slim

# Basic deps
RUN apt-get update && apt-get install -y --no-install-recommends \
	bash curl unzip ca-certificates git jq \
	build-essential autoconf automake nasm file \
	libpng-dev libjpeg-dev zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

# Install fnm (Fast Node Manager), skip shell edits
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "/opt/fnm" --skip-shell \
	&& ln -s /opt/fnm/fnm /usr/local/bin/fnm \
	&& fnm --version

# Optional: fnm shims dir in PATH (harmless)
ENV PATH="/root/.local/share/fnm:$PATH"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
