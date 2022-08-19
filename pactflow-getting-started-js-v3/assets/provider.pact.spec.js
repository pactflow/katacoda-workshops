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