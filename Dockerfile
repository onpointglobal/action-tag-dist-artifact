# Container image that runs your code
FROM node:14.4.0-alpine3.12

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
  && rm -rf /var/cache/apk/* 
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]