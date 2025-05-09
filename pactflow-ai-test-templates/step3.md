## Using Test Templates

Test Templates allow teams to generate contract tests that align with their existing style, frameworks, and SDK versions. By defining templates as code or providing additional contextual prompts, users can ensure that generated tests match their project conventions from the start, reducing manual refactoring and improving efficiency.

Test Templates are supported for all forms of test generation.

#### Providing Code Templates

When generating code, you can ask PactFlow to use a template test to customise output. Using the template, PactFlow AI will attempt to use the style, conventions and patterns it sees in your code. To provide a template, use the `--test-template` parameter, passing the location of a file containing the template.

**Example:**

Node JS:

```js
import { SpecificationVersion, PactV4, MatchersV3 } from "@pact-foundation/pact";
import { ProductAPI } from './product'

// Extract matchers here to improve readability when used in the test
const { like } = MatchersV3;

// Create a 3 level test hierarchy
//
// 1. Top level describe block containing the name of the API being tested
// 2. Describe block for the specific API endpoint
// 3. Test block for the specific test case
// 4. Execute the test case
// 5. Call the API under test
// 6. Assert the response
// 8. Use Pact matchers to constrain and test the Provider response
// 7. Use Jest matchers to assert the API client behaviour

// Top level - name of the API
describe("Product API", () => {
  // Use the PactV4 class, and serialise the Pact as V4 Pact Specification
  const pact = new PactV4({
    consumer: "ProductConsumer",
    provider: "ProviderProvider",
    spec: SpecificationVersion.SPECIFICATION_VERSION_V4,
  });

  // Level 2 - Describe block for the specific API endpoint
  describe("GET /products/:id", () => {

    // Level 3 - Test block for the specific test case
    test("given a valid product, returns 200", async () => {
      await pact
        .addInteraction()
        .given("a product with id 1 exists")
        .uponReceiving("a request for a valid product")
        // Avoid matchers on the request unless necessary
        .withRequest("GET", "/products/1", (builder) => {
          builder.headers({ Accept: "application/json" });
        })
        .willRespondWith(200, (builder) => {
          // Use loose matchers where possible, to avoid unnecessary constraints on the provider
          builder.jsonBody(
            like({
              id: 1,
              name: "Product 1",
              price: 100,
            })
          );
        })
        .executeTest(async (mockserver) => {
          // Instantiate the ProductAPI client
          const productAPI = new ProductAPI(mockserver.url);

          // Call the API under test
          const product = await productAPI.getProductById(1);

          // Use Jest matchers to assert the response
          expect(product).toEqual({
            id: 1,
            name: "Product 1",
            price: 100,
          });
        });
    });
  });
});

```

Save this code block as `src/pact.test.template`

## Generate a test

```sh
pactflow-ai generate \
  --code ./src/api.js \
  --code ./src/product.js \
  --output ./src/api.pact.spec.ts \
  --language typescript \
  --test-template ./src/pact.test.template
```{{exec}}

## Execute the test

👉🏼 `npm run test:pact`{{exec}}

### Check

Before moving on, please check

1. You have have a file called `src/pact.test.template`
2. You have been able to generate a test with PactFlow HaloAI providing the `--test-template` option and the above template.
