ARG JDK_VERSION=8
FROM aa8y/core:jdk${JDK_VERSION}

ARG SBT_VERSION=1.2.8

LABEL org.opencontainers.image.authors="https://github.com/aa8y" \
      org.opencontainers.image.description="SBT image based on aa8y/core (Alpine)." \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/aa8y/docker-sbt" \
      org.opencontainers.image.title="aa8y/sbt" \
      org.opencontainers.image.url="https://hub.docker.com/r/aa8y/sbt" \
      org.opencontainers.image.vendor="https://github.com/aa8y"

USER root
# Pre-1.x SBT didn't ship a runnable launcher in its archive — only
# sbt-launch.jar — so we seed /opt/sbt/bin/sbt with our wrapper script.
# SBT 1.x ships its own launcher in the tarball, which overwrites this
# when the archive is extracted below.
COPY sbt-0.12.sh /opt/sbt/bin/sbt

# SBT 1.x is published on GitHub releases; older 0.12.x lines were only
# ever published as bare launcher jars on the Maven Central mirror.
RUN apk add --no-cache --update wget bc && \
    mkdir -p /opt/sbt/bin && \
    case "${SBT_VERSION}" in \
      0.12.*) \
        SBT_URL="https://repo1.maven.org/maven2/org/scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar" && \
        wget -q "${SBT_URL}" -O /opt/sbt/bin/sbt-launch.jar && \
        chmod -R 755 /opt/sbt/bin/ \
        ;; \
      *) \
        SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" && \
        wget -q -O- --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
          "${SBT_URL}" | tar -xz -C /opt \
        ;; \
    esac && \
    ln -sf /opt/sbt/bin/sbt /bin/sbt && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

USER docker
WORKDIR $APP_DIR
CMD ["/bin/bash"]
