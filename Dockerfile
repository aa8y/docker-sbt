FROM aa8y/core:jdk8

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

ARG SBT_VERSION=1.0.3

USER root
RUN apk add --no-cache --update wget && \
    mkdir -p /opt/sbt/bin && \
    bash -c ' \
    if [[ "$SBT_VERSION" > "1.0.2" ]]; then \
      apk add --no-cache bc; \
    fi && \
    if [[ "$SBT_VERSION" > "0.13" ]]; then \
      if [[ "$SBT_VERSION" == "0.13.16" ]]; then \
        export SBT_URL="https://github.com/sbt/sbt/archive/v${SBT_VERSION}.tar.gz"; \
      else \
        export SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"; \
      fi && \
      cd /opt && \
      wget -qO- ${SBT_URL} | tar -C . -xzf -; \
    else \
      export SBT_URL="http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar" && \
      wget ${SBT_URL} -O /opt/sbt/bin/sbt-launch.jar && \
      echo java -Xms128M -Xmx512M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M \
        -jar /opt/sbt/bin/sbt-launch.jar "$@" > /opt/sbt/bin/sbt && \
      chmod 755 -R /opt/sbt; \
    fi' && \
    ln -s /opt/sbt/bin/sbt /bin/sbt && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

USER docker
CMD ["/bin/bash"]
