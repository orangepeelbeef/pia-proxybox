FROM alpine:latest
MAINTAINER "OJ LaBoeuf <orangepeelbeef@gmail.com>"

EXPOSE 1080 8112 3128

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
        apk add -q --progress --no-cache --update squid bash openvpn dante-server ca-certificates unbound wget curl runit deluge && \
        wget -q https://raw.githubusercontent.com/qdm12/updated/master/files/named.root.updated -O /etc/unbound/root.hints && \
        wget -q https://raw.githubusercontent.com/qdm12/updated/master/files/root.key.updated -O /etc/unbound/root.key && \
        chmod 440 /etc/unbound/root.hints /etc/unbound/root.key && \
        chown root:unbound /etc/unbound/root.hints /etc/unbound/root.key && \
        rm -rf /*.zip /var/cache/apk/*

COPY app/ /app/
COPY etc/ /etc/

CMD ["/app/start.sh"]