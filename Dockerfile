# Container image that runs your code
# FROM node:14.4.0-alpine3.12
FROM alpine:3.22.0

RUN apk add --update \
    bash \
    git \
    lcms2-dev \
    libpng-dev \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
    zlib-dev \
    musl \
    nasm \
    file \
    build-base \
    jq \
    libjpeg \
  && rm -rf /var/cache/apk/* 

# 2. Install NVM
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Pre‐install both Node versions and set 14.4.0 as the default
RUN . "$NVM_DIR/nvm.sh" \
	&& for v in 14.4.0 22.17.0; do nvm install "$v"; done \
	&& nvm alias default 14.4.0

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]