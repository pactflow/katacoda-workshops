# Consumer Contract Test

Now that we have written our consumer code, we need to test it, and ensure that it is compatible with its provider.

### Scope of a Consumer Contract Test

Ideally, contract tests should be closer to a _unit test_ for your API client class, and they should just focus on ensuring that the request creation and response handling are correct. Running in the context of a unit testing framework (Jest, JUnit, PHPUnit etc.) will give you the most flexible and reliable tests (even if the test is not strictly a unit test by definition).

_NOTE: In Bi-Directional Contract Testing however, you don't need to worry as much if these tests overlap into functional or other forms of tests like you would with Pact. This means they may be higher level - including initiated via a UI test (see this [Cypress example](https://github.com/pactflow/example-bdc-consumer-cypress))._

Usually, your application will be broken down into a number of sub-components, depending on what type of application your consumer is \(e.g. a Web application or another API\). This is how you might visualise the coverage of a consumer contract test:

![Scope of a consumer contract test](./assets/consumer-test-coverage.png)

Here, a _Collaborator_ is a component whose job is to communicate with another system. In our case, this is the `API` class communicating with the external `Product API` system. This is what we want our consumer test to inspect.

### Choosing a contract testing strategy

Pactflow currently supports pact files as a consumer contract format. In order to produce a consumer contract, you need to decide on a testing approach to capture the contract:

1. Use [Pact](docs.pact.io) - this will be the default choice for many, as it can both mock the API calls and produce a pact file
2. Use an existing mocking tools such as Wiremock or Mountebank, or record/replay tools, and convert the mocks to a Pact file after a successful run.

[Read more](https://docs.pactflow.io/docs/bi-directional-contract-testing/contracts/pact#strategies-to-capture-consumer-contracts) on these strategies.

As there are plenty of [example projects](https://docs.pactflow.io/docs/examples) for how to write Pact tests, *we will choose option (2)* and use [Mountebank](http://mbtest.org/) to mock our APIs.

### The contract test

Open up the API spec: ``example-bi-directional-consumer-mountebank/src/api.spec.js`{{open}}