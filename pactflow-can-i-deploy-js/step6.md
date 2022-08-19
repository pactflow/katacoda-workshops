# Testing (Verify) the provider

Now that we published our contract, we can have the provider verify it each time the provider build runs, to prevent introducing breaking changes to their consumers. This is referred to as "provider verification".

_NOTE: Credentials from the previous step will be required for this step to run._

#### Run the Provider tests

This step involves the following:

1. Starting the API
2. Telling Pact to use the contracts stored in Pactflow and where the Product API will be running with consumer, and which contracts to select with consumer version selectors
   1. Read more about [consumer version selectors](https://docs.pact.io/pact_broker/advanced_topics/consumer_version_selectors)
   2. See the [Recommended configuration for verifying pacts
      ](https://docs.pact.io/provider/recommended_configuration)
3. Running the Provider verification task

Create our Provider pact test file `provider.pact.spec.js`:

filename: `provider.pact.spec.js`:

```js
echo '
const { Verifier } = require("@pact-foundation/pact");
const { server } = require("./provider");

describe("Pact Verification", () => {
// (1) Starting the Provider API

before((done) => server.listen(8081, done));

it("validates the expectations of ProductService", () => {
// (2) Telling Pact to use the contracts stored in Pactflow and where the Product API will be running
const opts = {
logLevel: "INFO",
providerBaseUrl: "http://localhost:8081",
providerVersion: "1.0.0-someprovidersha",
provider: "katacoda-provider-v2",
consumerVersionSelectors: [{{ branch: "main"} }],
pactBrokerUrl: process.env.PACT_BROKER_BASE_URL,
// pactUrls: [
// `${process.env.PWD}/pacts/katacoda-consumer-katacoda-provider.json`,
// ],
publishVerificationResult: true,
enablePending: true,
};

    // (3) Running the Provider verification task
    return new Verifier(opts).verifyProvider().then((output) => {
      console.log("Pact Verification Complete!");
      console.log(output);
    });

});
});' > provider.pact.spec.js
```{{exec}}

And then run it: `npm run test:provider`{{execute}}

## Deploy

Now we've created our provider and confirmed it can meet the needs of its consumers, we can deploy it to production!

As with the consumer, we can first check if this is safe to do: `npm run can-deploy:provider`{{execute}}

Great! Because the Provider meets the needs of the consumer (and the consumer is not yet in production) it is safe to do.

_REMINDER: The `can-i-deploy` command is an important part of a CI/CD workflow, adding stage gates to prevent deploying incompatible applications to environments such as production_

You can read more about [can-i-deploy]
](https://docs.pact.io/pact_broker/can_i_deploy)

When an application version is deployed or released, we use the record-deployment or record-release commands provided by the Pact Broker CLI.

Deploy the provider: `npm run deploy:provider`{{execute}}

When a server based application is deployed to an instance, the previously deployed version is removed from that environment, and no longer needs to be supported. When an application like a mobile app or code library is released, the previously released versions are still available, and still need to be supported for a time at least.

`record-deployment` and `record-release` commands model these differences correctly, so the Broker always knows exactly which application version or versions are currently in an environment. This means that no matter whether an application is deployed or released, everyone can use can-i-deploy with the new --to-environment ENVIRONMENT option the same way, and can use the new { deployedOrReleased: true } consumer version selector for pact verification.


We have called `record-deployment` and marked our application version as deployed to `production`

You can read more about [recording deployments and releases
](https://docs.pact.io/pact_broker/recording_deployments_and_releases)

This diagram shows an illustrative CI/CD pipeline as it relates to our progress to date:

![first consumer pipeline run](./assets/provider-run.png)

## Check

Your dashboard should look something like this, where your provider has been marked as having been deployed to `prod`:

![pactflow-dashboard-provider-verifier](./assets/pactflow-dashboard-provider-verified-prod.png)
