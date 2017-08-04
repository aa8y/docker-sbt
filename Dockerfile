FROM openjdk:8-jdk-alpine

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

ARG SBT_VERSION=0.13.16

RUN apk add --no-cache --update \
      bash \
      wget && \
    mkdir -p /opt && \
    cd /opt && \
    export SHORT_VERSION=$(echo $SBT_VERSION | sed 's/\.//g') && \
    bash -c ' \
    if [[ "$SBT_VERSION" > "0.13" ]]; then \
      if [[ "$SBT_VERSION" > "0.13.16" || "$SBT_VERSION" == "0.13.16" ]]; then \
        export SBT_URL="https://cocl.us/sbt${SHORT_VERSION}tgz"; \
      else \
        export SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"; \
      fi && \
      wget -qO- ${SBT_URL} | tar -C . -xzf - && \
      ln -s /opt/sbt/bin/sbt /bin/sbt; \
    fi' && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
