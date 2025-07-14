# Container image that runs your code
# FROM node:14.4.0-alpine3.12
FROM alpine:3.22.0

RUN apk add --update \
    bash \
		curl \
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
ENV NVM_DIR=/root/.nvm \
	NVM_VERSION=v0.40.3 \
	NODE_DEFAULT=14.4.0 \
	NODE_ALT=22.17.0

# Fetch NVM, install it, then install both versions & set default
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
	&& source "$NVM_DIR/nvm.sh" \
	&& nvm install $NODE_DEFAULT \
	&& nvm install $NODE_ALT \
	&& nvm alias default $NODE_DEFAULT \
	&& nvm cache clear

# Ensure the default Node is on the PATH
ENV PATH="$NVM_DIR/versions/node/v${NODE_DEFAULT}/bin:$PATH"

# 5) Restore to plain sh if you like
SHELL ["/bin/sh", "-l"]


# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]