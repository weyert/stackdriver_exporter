FROM alpine:3.13 as certs
RUN apk --update add ca-certificates

FROM golang:latest as stackdriver-exporter

RUN mkdir /app
WORKDIR /app

COPY . .

RUN go build -o stackdriver_exporter .

RUN ls -la /app

FROM scratch

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=stackdriver-exporter /app /bin
COPY LICENSE /LICENSE

USER       nobody
ENTRYPOINT ["/bin/stackdriver_exporter"]

EXPOSE 9255