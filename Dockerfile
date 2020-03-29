FROM golang:1.14 as builder

# RUN apt-get update && apt-get install git build-base
RUN git clone https://github.com/go-shiori/shiori
WORKDIR shiori
RUN go mod download
RUN go build

# ========== END OF BUILDER ========== #

FROM alpine:latest

RUN apk update && apk --no-cache add dumb-init ca-certificates
COPY --from=builder /go/shiori/shiori /usr/local/bin/shiori

ENV SHIORI_DIR /srv/shiori/
EXPOSE 8080

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/shiori", "serve"]
