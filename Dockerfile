FROM alpine:3.11

RUN echo "@main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add ca-certificates emacs make bash boost-filesystem@main boost-iostreams@main boost-regex@main icu-libs@main ledger@testing

WORKDIR "/p.epij.nl"

ENTRYPOINT [ "make" ]
