FROM ubuntu:latest

RUN set -ex; \
	apt-get update; \
	apt-get install -y \
		rsync \
	; \
	rm -rf /var/lib/apt/lists/*; \
	ln -f -s /usr/bin/bash /usr/bin/sh ; \
	find / \( \
		-path /proc -o \
		-path /dev -o \
		-path /sys \
	\) -prune -o \( \
		-exec chmod g=u {} \; -a \
		-exec chgrp 0 {} \; \
	\)	

CMD ["sleep", "infinity"]

SHELL ["/bin/bash", "-c"]

