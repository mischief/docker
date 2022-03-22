FROM alpine:3 as build

ARG REPO=https://github.com/jart/cosmopolitan.git
ARG BRANCH=master
# cosmo build mode
ARG MODE=rel

RUN apk add git make zip bash coreutils

RUN git clone --depth=1 --branch=$BRANCH $REPO /build/cosmopolitan

WORKDIR /build/cosmopolitan
RUN make -j -l4 -O MODE=$MODE o/$MODE/tool/net/redbean.com
RUN cp o/$MODE/tool/net/redbean.com /redbean.com
RUN zip -d /redbean.com .ape

# force unpack
RUN bash /redbean.com -h 2>/dev/null >/dev/null

FROM scratch

COPY --from=build /redbean.com /redbean.com

VOLUME /data
VOLUME /site
VOLUME /assets

WORKDIR /

EXPOSE 80

ENTRYPOINT ["/redbean.com"]
CMD ["-p", "80", "-M", "536870912", "-D", "/data/", "-D", "/site/", "-A", "/assets/"]

