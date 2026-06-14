FROM aa8y/core:jdk8

ARG SBT_VERSION=1.2.8

LABEL org.opencontainers.image.authors="https://github.com/aa8y" \
      org.opencontainers.image.description="SBT image based on aa8y/core (Alpine)." \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/aa8y/docker-sbt" \
      org.opencontainers.image.title="aa8y/sbt" \
      org.opencontainers.image.url="https://hub.docker.com/r/aa8y/sbt" \
      org.opencontainers.image.vendor="https://github.com/aa8y"

USER root
RUN mkdir -p /opt/sbt/bin
COPY sbt-0.12.sh /opt/sbt/bin/sbt

# `apk --no-cache` does not seem to work. Removing that in favor of manual cleanup.
RUN apk add --update wget \
 && bash -c ' \
    if [[ "$SBT_VERSION" > "1.0.2" ]]; then \
      apk add --no-cache bc; \
    fi && \
    if [[ "$SBT_VERSION" > "0.13" ]]; then \
      export SBT_URL="https://piccolo.link/sbt-${SBT_VERSION}.tgz"; \
      cd /opt && \
      wget -qO- ${SBT_URL} | tar -C . -xzf -; \
    else \
      export SBT_URL="http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar" && \
      wget ${SBT_URL} -O /opt/sbt/bin/sbt-launch.jar && \
      chmod 755 -R /opt/sbt/bin/; \
    fi' \
 && ln -s /opt/sbt/bin/sbt /bin/sbt \
 && apk del --purge wget \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/*

USER docker
WORKDIR $APP_DIR
CMD ["/bin/bash"]
