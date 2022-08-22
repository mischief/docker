FROM bitnami/minideb:bullseye

LABEL org.opencontainers.image.authors mischief@offblast.org
LABEL org.opencontainers.image.source https://github.com/mischief/docker

RUN apt-get update && \
	apt-get install -y tini icecc

ENTRYPOINT ["tini", "--", "iceccd", "-u", "icecc", "-b", "/var/cache/icecc"]

