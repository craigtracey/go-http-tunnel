FROM golang:alpine as builder
EXPOSE 80 443 5223

RUN apk add --update git && rm -rf /var/cache/apk/*
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go get -u -ldflags="-s -w" -u github.com/mmatczuk/go-http-tunnel/cmd/...

FROM scratch
COPY --from=builder /etc/passwd /etc/passwd
EXPOSE 5223

COPY --from=builder /go/bin/tunneld /tunneld
COPY --from=builder /go/bin/tunnel /tunnel
