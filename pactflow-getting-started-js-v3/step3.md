## Testing the consumer

Now that we have our basic consumer code base, it's time to write our first Pact test!

Pact implements a specific type of integration test called a contract test. Martin Fowler defines it as follows:

> An integration contract test is a test at the boundary of an external service verifying that it meets the contract expected by a consuming service — [Martin Fowler](https://martinfowler.com/bliki/IntegrationContractTest.html)

Create the pact test:

Switch to `Tab 1` and click on the code block below to create filename: `consumer.pact.spec.js`:

```js
echo '
// (1) Import the pact library and matching methods
const { PactV3 } = require("@pact-foundation/pact");
const { MatchersV3 } = require("@pact-foundation/pact");
const { like, regex } = MatchersV3;
// This is the target of our Pact test, the ProductApiClient
const { ProductApiClient } = require("./api");
// This is domain object that the Consumer cares about, it will utilise
// the response from the provider and unmarshall it into the required model
const { Product } = require("./product");
// This is an assertion library, you can use whichever assertion language
// for your unit testing tool of choice
const chai = require("chai");
const expect = chai.expect;

// (2) Configure our Pact library
const mockProvider = new PactV3({
consumer: "katacoda-consumer-v3",
provider: "katacoda-provider-v3",
cors: true, // needed for katacoda environment
});

describe("Products API test", () => {
it("get product by ID", async () => {
// (3) Arrange: Setup our expected interactions
//
// We use Pact to mock out the backend API
const expectedProduct = { id: 10, type: "pizza", name: "Margharita" };

    mockProvider
      .given("a product with ID 10 exists")
      .uponReceiving("a request to get a product")
      .withRequest({
        method: "GET",
        path: "/products/10",
      })
      .willRespondWith({
        status: 200,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
        },
        body: like(expectedProduct),
      });

    // (4) Act: test our API client behaves correctly
    return mockProvider.executeTest(async (mockserver) => {
      // Note we configure the ProductApiClient API client dynamically to
      // point to the mock service Pact created for us, instead of the real one
      const api = new ProductApiClient(mockserver.url);
      const product = await api.getProduct(10);

      // (5) Assert that we got the expected response from our provider and our
      // client code unmarshalled it into the object  we expected
      expect(product).to.deep.equal(new Product(10, "Margharita", "pizza"));
    });

});
});' > consumer.pact.spec.js
```{{exec}}

There's a lot here, so let's break it down a little.

Steps `1`, `2`, `3` are JS specific activities to get Pact into a project. Steps `2`, `3`, and `4`, follow the [3A's (Arrange/Act/Assert) pattern](https://docs.microsoft.com/en-us/visualstudio/test/unit-test-basics?view=vs-2019#write-your-tests) for authoring unit tests.

1. Import the appropriate library - this will differ depending on language
2. Configure Pact. The name of the consumer and provider is important, as it uniquely identifies the applications in Pactflow
3. _Arrange_: we tell Pact what we're expecting our code to do and what we expect the provider to return when we do it
4. _Act_: we configure our API client to send requests to the Pact mock service (instead of the real provider) and we execute the call to the API
5. _Assert_: we check that our call to `getProduct(...)` worked as expected. This should just do what a regular unit test of this method would do.

### Run the test

`npm run test:consumer`{{execute}}

It should have created the following file:

`cat pacts/katacoda-consumer-katacoda-provider.json | jq .`{{execute}}

### Check

Before moving to the next step, check the following:

1. You could run the pact test with `npm run test:consumer`{{execute}}
1. There is a contract file that has been created at `pacts/katacoda-consumer-katacoda-provider.json`
  1. Try this in tab 1 `cat pacts/katacoda-consumer-katacoda-provider.json | jq .`{{execute}}
  1. You can open the file in Editor tab

_NOTE: in most setups, you wouldn't have a single file with everything in it, but for the purposes of keeping this workshop simple, we have a single test file that does it all._