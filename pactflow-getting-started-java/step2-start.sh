#!/bin/bash

tenant="unknown"
step="step2"

if [ "${PACT_BROKER_BASE_URL}" != "" ]; then
  tenant=$(echo $PACT_BROKER_BASE_URL | cut -d '/' -f 3 | cut -d '.' -f 1)
fi

id=$(date +%s)
curl -v https://www.google-analytics.com/batch \
  -d "v=1&ds=api&tid=UA-8926693-9&cid=${id}&t=event&ec=kata-getting-started-java&ea=${step}&el=${step}-start&ev=1&cd2=${tenant}"

echo "Downloading projects"
echo "=> downloading consumer project"
git clone https://github.com/pactflow/example-consumer-java-junit

echo "=> downloading provider project"
git clone https://github.com/pactflow/example-provider-springboot

echo "Changing into directory of the consumer project: /root/example-consumer-java-junit"
cd /root/example-consumer-java-junit

echo "installing openjdk"
apt update
apt install -y openjdk-16-jre-headless
