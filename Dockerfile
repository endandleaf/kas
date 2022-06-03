FROM golang:alpine AS build-env
ENV GO111MODULE=on
ADD . /go/src/app
WORKDIR /go/src/app
RUN apk --update add git curl tzdata && \
    go build -v -o /go/src/app/kas main.go && \
    export GO111MODULE=off && \
    go get github.com/GeertJohan/go.rice && \
    go get github.com/GeertJohan/go.rice/rice && \
    rice append --exec kas && \

WORKDIR /app
VOLUME ["/app/storage"]
HEALTHCHECK --interval=1m --timeout=10s \
  CMD curl -f http://localhost:1323/ping || exit 1
EXPOSE 1323
cmd ./kas
