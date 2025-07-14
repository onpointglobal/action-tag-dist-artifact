# syntax=docker/dockerfile:1

# 1) Allow overriding Node & Alpine versions via build-args
ARG NODE_VERSION=14.4.0
ARG ALPINE_VERSION=3.12

# 2) Use the official Node image with musl binaries
FROM node:${NODE_VERSION}-alpine${ALPINE_VERSION}

# 3) Install any extra runtime/build deps needed by your script
RUN apk add --no-cache \
	bash \
	git \
	lcms2-dev \
	libpng-dev \
	autoconf \
	automake \
	zlib-dev \
	nasm \
	file \
	build-base \
	jq \
	libjpeg \
	python3 && \
	ln -sf /usr/bin/python3 /usr/bin/python

# 4) Copy and set up your entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 5) Execute the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
