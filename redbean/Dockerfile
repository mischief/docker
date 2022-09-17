FROM alpine:3 as build

RUN wget -O /redbean.com https://redbean.dev/redbean-2.0.18.com
RUN echo '86f5db3d824c69f7ff2f250aa0ade86d8e2a6d40a3730b5e7eeafaed1945a570  redbean.com' > redbean.sha256
RUN sha256sum -c redbean.sha256 && rm redbean.sha256
RUN chmod +x /redbean.com && /redbean.com --assimilate

FROM scratch

COPY --from=build /redbean.com /redbean.com

VOLUME /data
VOLUME /site
VOLUME /assets

WORKDIR /

EXPOSE 80

ENTRYPOINT ["/redbean.com"]
CMD ["-p", "80", "-M", "536870912", "-D", "/data/", "-D", "/site/", "-A", "/assets/"]

