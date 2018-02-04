FROM openjdk:8-jdk-alpine

MAINTAINER Bruno Fitas <brunofitas@gmail.com>

ENV APACHE_MIRROR=http://apache.mirrors.pair.com

ENV ZOO_VERSION=3.4.11

ADD entrypoint.sh /opt/entrypoint.sh

RUN apk add --no-cache wget bash \
    && mkdir -p /opt/zookeeper \
    && wget -O - $APACHE_MIRROR/zookeeper/zookeeper-$ZOO_VERSION/zookeeper-$ZOO_VERSION.tar.gz \
    | tar -xzC /opt/zookeeper --strip-components=1 \
    && mkdir /var/zookeeper \
    && chmod +x /opt/entrypoint.sh \
    && apk del wget

VOLUME ["/opt/zookeeper/conf", "/var/zookeeper"]

EXPOSE 2181 2888 3888

CMD ["/opt/entrypoint.sh"]

HEALTHCHECK CMD [ $(echo ruok | nc 127.0.0.1:2181) == "imok" ] || exit 1
