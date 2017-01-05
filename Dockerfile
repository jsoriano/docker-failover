# Keepalived

FROM alpine:3.5

MAINTAINER Jaime Soriano <jsoriano@tuenti.com>

RUN apk add --no-cache keepalived bash netcat-openbsd \
	&& rm -fr /var/cache/apk/*

COPY ./files/start_failover.sh /usr/local/sbin/start_failover.sh

CMD [ "/bin/bash", "/usr/local/sbin/start_failover.sh" ]
