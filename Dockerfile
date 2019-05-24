FROM golang:alpine as build
RUN apk --no-cache --update upgrade && apk --no-cache add git build-base pkgconf rrdtool rrdtool-dev

ADD . /go/grafana-rrd-server
WORKDIR /go/grafana-rrd-server

RUN go get
RUN go build -ldflags="-s -w"
RUN chmod +x grafana-rrd-server

FROM mback2k/alpine:latest
RUN apk --no-cache --update upgrade && apk --no-cache add rrdtool

COPY --from=build /go/grafana-rrd-server/grafana-rrd-server /usr/local/bin/grafana-rrd-server

USER nobody

ENTRYPOINT [ "/usr/local/bin/grafana-rrd-server" ]
