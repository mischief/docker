FROM alpine:3 as luarocks

RUN apk add luarocks5.1 zip

# only pure-lua rocks work here
RUN for f in markdown; do \
	luarocks-5.1 --tree /rocks install $f; \
    done

COPY --from=ghcr.io/mischief/redbean:latest /redbean.com /redbean.com

ADD . /src/

# put lua rocks in magic redbean zip path, they can be require'd normally
RUN mkdir /pack && \
	ln -s /rocks/share/lua/5.1 /pack/.lua && \
	ln -s /src/init.lua /pack/.init.lua && \
	cd /pack && zip -0r /redbean.com .

FROM scratch
COPY --from=0 /redbean.com /redbean.com
ENTRYPOINT ["/redbean.com"]
CMD ["-s", "-p", "80"]
EXPOSE 80

