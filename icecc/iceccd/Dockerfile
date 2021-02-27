FROM bitnami/minideb:buster 

RUN apt-get update && \
	apt-get install -y tini icecc

ENTRYPOINT ["tini", "--", "iceccd", "-u", "icecc", "-b", "/var/cache/icecc"]

