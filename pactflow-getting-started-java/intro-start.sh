#!/bin/bash
echo "Installing OpenJDK 17 for consumer"
mkdir -p /usr/java
cd /usr/java
wget -c https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
tar -xf openjdk-17.0.2_linux-x64_bin.tar.gz
echo 'export JAVA_HOME=/usr/java/jdk-17.0.2' >> ~/.bashrc
echo "export PATH=/usr/java/jdk-17.0.2/bin:${PATH}" >> ~/.bashrc
source ~/.bashrc
echo "Installing OpenJDK 17 for provider"
mkdir -p /usr/java
cd /usr/java
wget -c https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
tar -xf openjdk-17.0.2_linux-x64_bin.tar.gz
echo "Installing jq"
apt --yes install jq && cd ~ && clear && echo "Welcome to the PactFlow Tutorial, all the dependencies are installed, and you should be good to go!"
