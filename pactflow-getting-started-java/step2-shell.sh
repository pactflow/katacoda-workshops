#!/bin/bash
echo "Downloading projects"
echo "=> downloading consumer project"
git clone https://github.com/pactflow/example-consumer-java-junit

echo "=> downloading provider project"
git clone https://github.com/pactflow/example-provider-springboot

echo "Changing into directory of the consumer project: /root/example-consumer-java-junit"
cd /root/example-consumer-java-junit
