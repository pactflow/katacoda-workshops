echo "Changing into directory of the provider project: /root/example-provider-springboot"
cd /root/example-provider-springboot

echo "Setting env var `PACT_BROKER_PUBLISH_VERIFICATION_RESULTS` to true, to publish provider verification results back to the broker"
export PACT_BROKER_PUBLISH_VERIFICATION_RESULTS=true

echo "Installing Java 11 due to (current) issues with OpenJDK 15"
cd /usr/java
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
tar -xf openjdk-11+28_linux-x64_bin.tar.gz
export JAVA_HOME="/usr/java/jdk-11"
export PATH="/usr/java/jdk-11/bin:${PATH}"
rm -rf /usr/java/openjdk-15