FROM alpine

RUN echo 'syncthing:x:1000:1000::/var/syncthing:/sbin/nologin' >> /etc/passwd \
    && echo 'syncthing:!::0:::::' >> /etc/shadow \
    && mkdir /var/syncthing \
    && chown -R syncthing /var/syncthing

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

ENV release=v1.2.2
RUN mkdir /syncthing \
    && cd /syncthing \
    && curl -s -L https://github.com/syncthing/syncthing/releases/download/${release}/syncthing-linux-arm-${release}.tar.gz \
    | tar -zx \
    && mv syncthing-linux-arm-${release}/syncthing . \
    && rm -rf syncthing-linux-arm-${release}

USER syncthing
ENV STNOUPGRADE=1
ENTRYPOINT ["/syncthing/syncthing", "-home", "/var/syncthing/config", "-gui-address", "0.0.0.0:8384"]
