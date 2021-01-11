#!/bin/bash

echo "Configuring provider step to use JDK 11"
export JAVA_HOME="/usr/java/jdk-11"
export PATH="/usr/java/jdk-11/bin:${PATH}"