#!/bin/bash

java -XX:+UseConcMarkSweepGC -Xms1G -Xmx2G -Xss256m -jar /opt/sbt/bin/sbt-launch.jar "$@"
