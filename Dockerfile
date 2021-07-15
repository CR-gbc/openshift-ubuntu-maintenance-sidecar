FROM ubuntu:latest

RUN set -ex; \
	apt-get update; \
	apt-get install -y \
		rsync \
	; \
	rm -rf /var/lib/apt/lists/*	

CMD ["sleep", "infinity"]
