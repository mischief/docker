FROM alpine:3 as build

RUN wget -qO /redbean.com https://redbean.dev/redbean-1.5.com
RUN echo "a4189a6f9d540e5f400bbe40319b262dc622d64e32985a066e6f0b82ea06cd0d  /redbean.com" > /redbean.txt
RUN sha256sum -c /redbean.txt && rm /redbean.txt

RUN apk add --no-cache zip bash
RUN zip -d /redbean.com .ape

RUN chmod +x /redbean.com
RUN bash /redbean.com -h >/dev/null

FROM scratch

COPY --from=build /redbean.com /redbean.com

VOLUME /data
VOLUME /site

WORKDIR /

EXPOSE 80

ENTRYPOINT ["/redbean.com"]
CMD ["-p", "80", "-D", "/data/", "-D", "/site/"]


