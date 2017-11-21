FROM aa8y/core:jdk8

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

ARG SBT_VERSION=1.0.3

USER root
RUN mkdir -p /opt/sbt/bin
COPY sbt-0.12.sh /opt/sbt/bin/sbt
RUN apk add --no-cache --update wget && \
    bash -c ' \
    if [[ "$SBT_VERSION" > "1.0.2" ]]; then \
      apk add --no-cache bc; \
    fi && \
    if [[ "$SBT_VERSION" > "0.13" ]]; then \
      if [[ "$SBT_VERSION" == "0.13.16" ]]; then \
        export SBT_URL="https://cocl.us/sbt-0.13.16.tgz"; \
      else \
        export SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"; \
      fi && \
      cd /opt && \
      wget -qO- ${SBT_URL} | tar -C . -xzf -; \
    else \
      export SBT_URL="http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar" && \
      wget ${SBT_URL} -O /opt/sbt/bin/sbt-launch.jar && \
      chmod 755 -R /opt/sbt/bin/; \
    fi' && \
    ln -s /opt/sbt/bin/sbt /bin/sbt && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

USER docker
WORKDIR $APP_DIR
CMD ["/bin/bash"]
