## Testing the consumer

Now that we have our basic consumer code base, it's time to write our first Pact test!

Pact implements a specific type of integration test called a contract test. Martin Fowler defines it as follows:

> An integration contract test is a test at the boundary of an external service verifying that it meets the contract expected by a consuming service — [Martin Fowler](https://martinfowler.com/bliki/IntegrationContractTest.html)

Create the pact test:

Switch to `Tab 1` and click on the code block below to create filename: `consumer.pact.spec.js`:

```js
echo '// (1) Import the pact library and matching methods
const { Pact } = require("@pact-foundation/pact");
const { ProductApiClient } = require("./api");
const { Product } = require("./product");
const { Matchers } = require("@pact-foundation/pact");
const { like, regex } = Matchers;
const chai = require("chai");
const expect = chai.expect;

// (2) Configure our Pact library
const mockProvider = new Pact({
  consumer: "katacoda-consumer",
  provider: "katacoda-provider",
  cors: true, // needed for katacoda environment
});

describe("Products API test", () => {
  // (3) Setup Pact lifecycle hooks
  before(() => mockProvider.setup());
  afterEach(() => mockProvider.verify());
  after(() => mockProvider.finalize());

  it("get product by ID", async () => {
    // (4) Arrange
    const expectedProduct = { id: 10, type: "pizza", name: "Margharita" };

    await mockProvider.addInteraction({
      state: "a product with ID 10 exists",
      uponReceiving: "a request to get a product",
      withRequest: {
        method: "GET",
        path: "/products/10",
      },
      willRespondWith: {
        status: 200,
        headers: {
          "Content-Type": regex({
            generate: "application/json; charset=utf-8",
            matcher: "^application/json",
          }),
        },
        body: like(expectedProduct),
      },
    });

    // (5) Act
    const api = new ProductApiClient(mockProvider.mockService.baseUrl);
    const product = await api.getProduct(10);

    // (6) Assert that we got the expected response
    expect(product).to.deep.equal(new Product(10, "Margharita", "pizza"));
  });
});' > consumer.pact.spec.js
```{{exec}}

There's a lot here, so let's break it down a little.

1. Import the appropriate library - this will differ depending on language
2. Configure Pact. The name of the consumer and provider is important, as it uniquely identifies the applications in Pactflow
3. Here we setup some Pact lifecycle hooks. 
   - First we run `setup()`{{}} before all of the tests run to start the Pact runtime). 
   - We also configure two other lifecycle hooks to `verify()`{{}} that the test was successful and write out the pact file 
   - We call `finalize()`{{}} when the suite is finished. This specific step will vary depending on which language you use
4. _Arrange_: we tell Pact what we're expecting our code to do and what we expect the provider to return when we do it
5. _Act_: we configure our API client to send requests to the Pact mock service (instead of the real provider) and we execute the call to the API
6. _Assert_: we check that our call to `getProduct(...)`{{}} worked as expected. This should just do what a regular unit test of this method does.

### Run the test

`npm run test:consumer`{{execute}}

It should have created the following file:

`cat pacts/katacoda-consumer-katacoda-provider.json`{{execute}}

### Check

Before moving to the next step, check the following:

1. You could run the pact test with `npm run test:consumer`{{execute}}
1. There is a contract file that has been created at `pacts/katacoda-consumer-katacoda-provider.json`
  1. Try this in tab 1 `cat pacts/katacoda-consumer-katacoda-provider.json | jq .`{{execute}}
  1. You can open the file in Editor tab

_NOTE: in most setups, you wouldn't have a single file with everything in it, but for the purposes of keeping this workshop simple, we have a single test file that does it all._