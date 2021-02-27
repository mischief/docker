FROM bitnami/minideb:buster 

RUN apt-get install -y tini icecc

ENTRYPOINT ["tini", "--", "icecc-scheduler", "-u", "icecc"]

