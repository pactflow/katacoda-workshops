echo "Changing into directory of the provider project: /root/example-provider-springboot"
cd /root/example-provider-springboot

echo "Setting env var $(PACT_BROKER_PUBLISH_VERIFICATION_RESULTS) to true, to publish provider verification results back to the broker"
export PACT_BROKER_PUBLISH_VERIFICATION_RESULTS=true

echo "Configuring provider step to use JDK 11"
export JAVA_HOME="/usr/java/jdk-11"
export PATH="/usr/java/jdk-11/bin:${PATH}"
