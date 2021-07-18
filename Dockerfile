FROM ubuntu:latest

ARG CHANGE_USER=0

RUN set -ex; \
	apt-get update ; \
	echo 'tzdata tzdata/Areas select America' | debconf-set-selections ; \
	echo 'tzdata tzdata/Zones/America select Vancouver' | debconf-set-selections ; \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y \
		build-essential \
		ca-certificates \
		tzdata \
		sed \
		curl \
		git \
		neovim \
		rsync \
		composer \
	; \
	rm -rf /var/lib/apt/lists/* ; \
	useradd -u 12358 -g 0 -m -s /bin/bash sidecar ; \
	ln -f -s /usr/bin/bash /usr/bin/sh ; \
	mv /usr/bin/dpkg /usr/bin/ddpkg ; \
	echo -e '#!/bin/bash\n/usr/bin/ddpkg --force-not-root "$@"\n' > /usr/bin/dpkg ; \
	chmod +x /usr/bin/dpkg ; \ 
	find / \( \
		-path /proc -o \
		-path /dev -o \
		-path /sys \
	\) -prune -o \( \
		-exec chmod g=u {} \; -a \
		-exec chgrp 0 {} \; -a \
		-exec chown $CHANGE_USER {} \; \
	\)	

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 15.14.0
ENV NPM_VERSION 7.7.6

COPY ./nvminstall.sh /
RUN set -ex ; \
	mkdir -p $NVM_DIR ; \
	bash /nvminstall.sh ; \
	rm /nvminstall.sh ; \
	source $NVM_DIR/nvm.sh ; \
	nvm install $NODE_VERSION ; \
	nvm alias default $NODE_VERSION ; \
	nvm use default ; \
	npm install npm@$NPM_VERSION -g

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]

CMD ["sleep", "infinity"]

SHELL ["/bin/bash", "-c"]

