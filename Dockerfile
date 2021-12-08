ARG ARCH=
FROM ${ARCH}alpine:3

ADD msmtprc.tpl /var/tmp/
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN apk add --no-cache msmtp jq && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing envsubst

ENTRYPOINT [ "/entrypoint.sh" ]
