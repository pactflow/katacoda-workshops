#!/bin/bash
echo "Installing OpenJDK 15"
mkdir -p /usr/java
cd /usr/java
wget -c https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz
tar -xf openjdk-15.0.2_linux-x64_bin.tar.gz
export JAVA_HOME="/usr/java/jdk-15.0.2"
export PATH="/usr/java/jdk-15.0.2/bin:${PATH}"
echo "Installing jq"
apt --yes install jq && cd ~ && clear && echo "Welcome to the Pactflow Tutorial, all the dependencies are installed, and you should be good to go!"
