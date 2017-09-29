# imagem default
FROM vault:0.8.0-rc1
MAINTAINER Evandro Couto <vandocouto@gmail.com>

# run
RUN apk update && \
    apk add vim bash tree

COPY config.hcl /vault/config
COPY key.pem    /vault/config
COPY cert.pem   /vault/config