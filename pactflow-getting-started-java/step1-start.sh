#!/bin/bash

tenant="unknown"
step="step1"

if [ "${PACT_BROKER_BASE_URL}" != "" ]; then
  tenant=$(echo $PACT_BROKER_BASE_URL | cut -d '/' -f 3 | cut -d '.' -f 1)
fi

id=$(date +%s)
curl -v https://www.google-analytics.com/batch \
  -d "v=1&ds=api&tid=UA-8926693-9&cid=${id}&t=event&ec=kata-getting-started-java&ea=${step}&el=${step}-start&ev=1&cd1=${tenant}"

echo "Installing Java 11 due to (current) issues with OpenJDK 15"
cd /usr/java
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar -xf openjdk-11+28_linux-x64_bin.tar.gz
export JAVA_HOME="/usr/java/jdk-11"
export PATH="/usr/java/jdk-11/bin:${PATH}"