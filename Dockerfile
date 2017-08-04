FROM openjdk:8-jdk-alpine

MAINTAINER Arun Allamsetty <arun.allamsetty@gmail.com>

ARG SBT_VERSION=0.13.16

RUN apk add --no-cache --update \
      bash \
      wget && \
    mkdir -p /opt/sbt/bin && \
    export SHORT_VERSION=$(echo $SBT_VERSION | sed -E 's/\.|-//g' | tr A-Z a-z) && \
    bash -c ' \
    if [[ "$SBT_VERSION" > "0.13" ]]; then \
      cd /opt && \
      if [[ "$SBT_VERSION" > "0.13.16" || "$SBT_VERSION" == "0.13.16" ]]; then \
        export SBT_URL="https://cocl.us/sbt${SHORT_VERSION}tgz"; \
      else \
        export SBT_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"; \
      fi && \
      wget -qO- ${SBT_URL} | tar -C . -xzf -; \
    else \
      export SBT_URL="http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch//${SBT_VERSION}/sbt-launch.jar" && \
      wget ${SBT_URL} -O /opt/sbt/bin/sbt-launch.jar && \
      echo java -Xms128M -Xmx512M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M \
        -jar /opt/sbt/bin/sbt-launch.jar "$@" > /opt/sbt/bin/sbt && \
      chmod 755 -R /opt/sbt; \
    fi' && \
    ln -s /opt/sbt/bin/sbt /bin/sbt && \
    apk del --purge wget && \
    rm -rf /var/cache/apk/*

CMD ["/bin/bash"]
