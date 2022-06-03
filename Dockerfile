FROM golang:alpine AS build-env
ENV GO111MODULE=on
ADD . /go/src/app
WORKDIR /go/src/app
RUN apk --update add git curl tzdata && \
    go build -v -o /go/src/app/kas main.go && \
    export GO111MODULE=off && \
    go get github.com/GeertJohan/go.rice && \
    go get github.com/GeertJohan/go.rice/rice && \
    rice append --exec kas 
VOLUME ["/go/src/app/storage"]
EXPOSE 80
HEALTHCHECK --interval=1m --timeout=10s \
  CMD curl -f http://localhost:80/ping || exit 1
CMD ./kas
