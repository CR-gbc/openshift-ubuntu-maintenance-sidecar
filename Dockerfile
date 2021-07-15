FROM ubuntu:latest

ARG CHANGE_USER=0

RUN set -ex; \
	apt-get update; \
	apt-get install -y \
		git \
		vim \
		rsync \
	; \
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

CMD ["sleep", "infinity"]

SHELL ["/bin/bash", "-c"]

