echo "Changing into directory of the provider project: /root/example-provider-springboot"
cd /root/example-provider-springboot

echo "Setting env var `PACT_BROKER_PUBLISH_VERIFICATION_RESULTS` to true, to publish provider verification results back to the broker"
export PACT_BROKER_PUBLISH_VERIFICATION_RESULTS=true