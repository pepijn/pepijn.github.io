FROM alpine:3.11

RUN apk update && apk add ca-certificates emacs make bash

WORKDIR "/p.epij.nl"

ENTRYPOINT [ "make" ]
