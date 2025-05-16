## Using Test Templates

Test Templates allow teams to generate contract tests that align with their existing style, frameworks, and SDK versions. By defining templates as code or providing additional contextual prompts, users can ensure that generated tests match their project conventions from the start, reducing manual refactoring and improving efficiency.

Test Templates are supported for all forms of test generation.

#### Providing Code Templates

When generating code, you can ask PactFlow to use a template test to customise output. Using the template, PactFlow AI will attempt to use the style, conventions and patterns it sees in your code. To provide a template, use the `--test-template` parameter, passing the location of a file containing the template.

**Example:**

Node JS:

```js
import { SpecificationVersion, PactV4, MatchersV3 } from "@pact-foundation/pact";
import { ThingAPI } from './thing'

// Extract matchers here to improve readability when used in the test
const { like } = MatchersV3;

// Top level - name of the API
describe("🧱 Thing API", () => {
  // Use the PactV4 class, and serialise the Pact as V4 Pact Specification
  const pact = new PactV4({
    consumer: "ThingConsumer",
    provider: "ThingProvider",
    spec: SpecificationVersion.SPECIFICATION_VERSION_V4,
    logLevel: "error",
  });

  // Level 2 - Describe block for the specific API endpoint
  describe("🔌 GET /thing/:id", () => {

    // Level 3 - Test block for the specific test case
    test("🧪 given a valid thing, returns 200", async () => {
      await pact
        .addInteraction()
        .given("a thing with id 1 exists")
        .uponReceiving("a request for a valid thing")
        .withRequest("GET", "/thing/1", (builder) => {
          builder.headers({ Accept: "application/json" });
        })
        .willRespondWith(200, (builder) => {
          builder.jsonBody(
            like({
              id: 1,
              name: "Thing 1",
              price: 100,
            })
          );
        })
        .executeTest(async (mockserver) => {
          const ThingAPI = new ThingAPI(mockserver.url);

          const Thing = await ThingAPI.getThingById(1);

          expect(Thing).toEqual({
            id: 1,
            name: "Some 1",
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
