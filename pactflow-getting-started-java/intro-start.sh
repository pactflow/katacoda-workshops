#!/bin/bash
echo "Installing OpenJDK 24 for consumer"
mkdir -p /usr/java
cd /usr/java
wget -c https://download.java.net/java/GA/jdk24.0.2/fdc5d0102fe0414db21410ad5834341f/12/GPL/openjdk-24.0.2_linux-x64_bin.tar.gz
tar -xf openjdk-24.0.2_linux-x64_bin.tar.gz
echo 'export JAVA_HOME=/usr/java/jdk-24.0.2' >> ~/.bashrc
echo "export PATH=/usr/java/jdk-24.0.2/bin:${PATH}" >> ~/.bashrc
source ~/.bashrc
echo "Installing OpenJDK 11 for provider"
mkdir -p /usr/java
cd /usr/java
wget -c https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz
tar -xf openjdk-11_linux-x64_bin.tar.gz
echo "Installing jq"
apt --yes install jq && cd ~ && clear && echo "Welcome to the PactFlow Tutorial, all the dependencies are installed, and you should be good to go!"
