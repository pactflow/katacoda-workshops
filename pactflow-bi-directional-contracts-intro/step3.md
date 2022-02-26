# Testing (Verify) the provider

Now that we have a provider contract, we need to do two things to prevent introducing breaking changes to our consumers.

1. Ensure the API doesn't drift from it's OAS
2. Ensure the OAS doesn't change such that it could break any of its consumers

_NOTE: Credentials from the previous step will be required for this step to run._

### Scope of a Provider test

TBC - discuss options and tradeoffs here (code gen, unit test and functional tests)

<!-- On the Provider side, Pact needs to replay all of the interactions \(usually HTTP requests\) against your service. There are a number of choices that can be made here, but usually these are the choices:

- Invoke just the controller layer \(in an MVC app, or the "Adapter" in our diagram\) and stub out layers beneath
- Choosing a real vs mocked out database
- Choosing to hit mock HTTP servers or mocks for external services

Generally speaking, we test the entire service and mock out external services such as downstream APIs \(which would need their own set of Pact tests\) and databases. This gives you some of the benefits of an integration test without the high costs of maintenance.

This is how you might visualise the coverage of a provider Pact test:

![Provider side Pact test scope](./assets/provider-test-coverage.png) -->

#### Run the Provider tests

This step involves the following:

1. Starting the API \(line 5\)
1. Telling Pact to use the contracts stored in Pactflow and where the Product API will be running \(lines 8-16\)
1. Running the Provider verification task \(line 18\)

Create our Provider pact test file `provider.pact.spec.js`:

<pre class="file" data-filename="provider.pact.spec.js" data-target="replace">
const { Verifier } = require('@pact-foundation/pact');
const { server} = require('./provider');

describe("Pact Verification", () => {
  before((done) => server.listen(8081, done))

  it("validates the expectations of ProductService",  () => {
    const opts = {
      logLevel: "INFO",
      providerBaseUrl: "http://localhost:8081",
      providerVersion: "1.0.0-someprovidersha",
      provider: "katacoda-provider",
      consumerVersionSelectors: [{ tag: 'master', latest: true }, { tag: 'prod', latest: true } ],
      pactBrokerUrl: process.env.PACT_BROKER_BASE_URL,
      publishVerificationResult: true,
      enablePending: true
    }

    return new Verifier(opts).verifyProvider()
    .then(output => {
        console.log("Pact Verification Complete!")
        console.log(output)
      })
  })
});
</pre>

And then run it: `npm run test:provider`{{execute}}

## Deploy

Now we've created our provider and confirmed it can meet the needs of its consumers, we can deploy it to production!

As with the consumer, we can first check if this is safe to do: `npm run can-deploy:provider`{{execute}}

Great! Because the Provider meets the needs of the consumer (and the consumer is not yet in production) it is safe to do.

Deploy the provider: `npm run deploy:provider`{{execute}}

_REMINDER: The `can-i-deploy` command is an important part of a CI/CD workflow, adding stage gates to prevent deploying incompatible applications to environments such as production_

This diagram shows an illustrative CI/CD pipeline as it relates to our progress to date:

![first consumer pipeline run](./assets/provider-run.png)

## Check

Your dashboard should look something like this, where your provider has been tagged as having been deployed to `prod`:

![pactflow-dashboard-provider-verifier](./assets/pactflow-dashboard-provider-verified-prod.png)
