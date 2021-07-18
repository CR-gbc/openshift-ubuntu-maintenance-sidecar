FROM ubuntu:latest

ARG CHANGE_USER=0

RUN set -ex; \
	apt-get update ; \
	echo 'tzdata tzdata/Areas select America' | debconf-set-selections ; \
	echo 'tzdata tzdata/Zones/America select Vancouver' | debconf-set-selections ; \
	DEBIAN_FRONTEND="noninteractive" apt-get install -y \
		tzdata \
		sed \
		curl \
		git \
		neovim \
		rsync \
		composer \
	; \
	useradd -u 12358 -g 0 -m -s /bin/bash sidecar ; \
	rm -rf /var/lib/apt/lists/*; \
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

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["bash", "/docker-entrypoint.sh"]

CMD ["sleep", "infinity"]

SHELL ["/bin/bash", "-c"]

