# Testing (Verify) the provider

Now that we published our contract, we can have the provider verify it each time the provider build runs, to prevent introducing breaking changes to their consumers. This is referred to as "provider verification".

_NOTE: Credentials from the previous step will be required for this step to run._

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


## Check

Your dashboard should look something like this, showing the pact as verified (you can ignore any tags applied for now).

![pactflow-dashboard-provider-verifier](./assets/pactflow-dashboard-provider-verified-prod.png)