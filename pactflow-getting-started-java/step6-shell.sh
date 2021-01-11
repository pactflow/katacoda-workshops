#!/bin/bash

echo "Changing into directory of the provider project: /root/example-provider-springboot"
cd /root/example-provider-springboot

echo "Configuring provider step to use JDK 11"
export JAVA_HOME="/usr/java/jdk-11"
export PATH="/usr/java/jdk-11/bin:${PATH}"