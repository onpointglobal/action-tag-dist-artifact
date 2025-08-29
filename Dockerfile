# Container image that runs your code
FROM alpine:3.22

# System deps
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
	libjpeg-turbo-dev \
	&& rm -rf /var/cache/apk/* 

# Install fnm (Fast Node Manager)
ENV FNM_DIR=/opt/fnm
RUN mkdir -p $FNM_DIR \
	&& curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir $FNM_DIR --skip-shell \
	&& ln -s $FNM_DIR/fnm /usr/local/bin/fnm

	# Ensure fnm shims are discoverable later
ENV PATH="/root/.local/share/fnm:$PATH"
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]