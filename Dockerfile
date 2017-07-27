FROM openjdk:8-jdk-alpine

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

LABEL co.aa8y.docker.sbt.license="mit" \
      co.aa8y.docker.sbt.release-date="2017-07-27" \
      co.aa8y.docker.sbt.version="0.2.0"

ENV SBT_VERSION 0.13.15
ARG SBT_DIR=/opt/sbt
ARG SBT_URL=https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz

RUN apk add --no-cache --update \
      bash \
      wget && \
    mkdir -p $SBT_DIR && \
    cd $SBT_DIR && \
    wget -qO- ${SBT_URL} | tar -C . -xzf - && \
    mv sbt ${SBT_VERSION} && \
    ln -s ./${SBT_VERSION} ./current && \
    ln -s ${SBT_DIR}/current/bin/sbt /bin/sbt && \
    sbt clean && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
