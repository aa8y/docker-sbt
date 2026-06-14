ARG JDK_VERSION=21
FROM aa8y/core:jdk${JDK_VERSION}

ARG SBT_VERSION=1.12.11

LABEL org.opencontainers.image.authors="https://github.com/aa8y" \
      org.opencontainers.image.description="SBT image based on aa8y/core (Alpine)." \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/aa8y/docker-sbt" \
      org.opencontainers.image.title="aa8y/sbt" \
      org.opencontainers.image.url="https://hub.docker.com/r/aa8y/sbt" \
      org.opencontainers.image.vendor="https://github.com/aa8y"

USER root
RUN apk add --no-cache --update wget && \
    wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
      "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | \
      tar -xz -C /opt && \
    ln -s /opt/sbt/bin/sbt /bin/sbt && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*
USER docker

WORKDIR $APP_DIR
CMD ["/bin/bash"]
