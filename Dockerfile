# Container image that runs your code
FROM alpine:3.22

# System deps
RUN apk add --no-cache \
	bash \
	curl \
	unzip \
	git \
	jq \
	ca-certificates \
	lcms2-dev \
	libpng-dev \
	libjpeg-turbo-dev \
	gcc g++ make autoconf automake zlib-dev musl nasm file build-base \
	&& rm -rf /var/cache/apk/* 

# Install fnm (Fast Node Manager)
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- \
	--install-dir "/opt/fnm" \
	--skip-shell \
	&& ln -sf /opt/fnm/fnm /usr/local/bin/fnm \
	&& /usr/local/bin/fnm --version

ENV FNM_NODE_DIST_MIRROR="https://unofficial-builds.nodejs.org/download/release"

	# Ensure fnm shims are discoverable later
ENV PATH="/root/.local/share/fnm:$PATH"
# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]