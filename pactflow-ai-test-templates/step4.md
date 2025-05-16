
## Passing Additional Prompts

When generating code, you can specify additional instructions for PactFlow AI to use to customize the output. For example, you might wish to provide extra guidelines or configurations, useful for handling special cases, overriding default behaviors, or adding constraints to the generation logic for a specific test.

If you notice having to consistently change something in the generation, this is a good opportunity to add it to the prompt file.

To customize the output with prompts, use the `--instructions` parameter. Instructions can be provided as a direct string or read from a local file.

**Example**

To provide specific updates or constraints for the test generation, use a concise instruction like:

`--instructions "Include the 'X-HMAC-SIGNATURE' header in all GET requests (format: 'SHA256-HMAC-SIGNATURE: {sig}')"`

You can try this now

## Generate a test

```sh
pactflow-ai generate \
  --code ./src/api.js \
  --code ./src/product.js \
  --output ./src/api.pact.spec.ts \
  --language typescript \
  --instructions "Include the 'X-HMAC-SIGNATURE' header in all GET requests (format: 'SHA256-HMAC-SIGNATURE: {sig}')"
```{{exec}}

## Execute the test

👉🏼 `npm run test:pact`{{exec}}


**Example:**

Alternatively, you can load instructions from a file `--instructions @/path/to/instructions.txt`

This would instruct the test generation process to read the file content and use it as the instruction.

You can try this now.

`prompts.txt`:

```md
* Make sure to cover happy and non-happy paths
  * Specifically, ensure to include test cases for the positive (200) scenario and negative scenarios, specifically the case of 400, 401 and 404
* Only include endpoints/properties used by the API client - do not include additional fields in the OAS that are not in the client code
  * Check the properties used in the Product class and similar models to help make this determination
* Use the Jest testing framework
* Use the native Jest expect (https://jestjs.io/docs/expect) matchers such as `toEqual` and `toBeTruthy`
* Prefer the use of the async/await pattern when using Promises
* Use a 3 level hierarchy for tests
  1. Level 1 should be the API under test as a `describe` block e.g. "Product API"
  2. Level 2 should be the endpoint as a `describe` block e.g. "GET /products/:id", "POST /products"
  3. Level 3 should be the scenario as a `test` block e.g. "Given a valid user, returns a 200", "Given an invalid user, returns a 400"
```

## Generate a test

```sh
pactflow-ai generate \
  --code ./src/api.js \
  --code ./src/product.js \
  --output ./src/api.pact.spec.ts \
  --language typescript \
  --instructions @./prompts.txt
```{{exec}}

## Execute the test

👉🏼 `npm run test:pact`{{exec}}

### Passing a template and prompt files

For the best results, we recommend combining the test template with a set of prompts.

Using the template and prompt files created in this tutorial, you might find the test work without modification:

```sh
pactflow-ai generate \
  --output ./src/api.pact.spec.ts \
  --language typescript \
  --openapi ./products.yml \
  --endpoint "**" \
  --code ./src/product.js \
  --code ./src/api.js \
  --template ./src/pact.test.template \
  --instructions @./src/test.instructions.txt
```

## Execute the test

👉🏼 `npm run test:pact`{{exec}}


### Check

1. You have been able generate a test using PactFlow AI with the `--instructions` flag and some text on the command line to customize the output.
2. You have been able generate a test using PactFlow AI with the `--instructions` flag and a path for a prompt file containing one or many prompts to customize the output.
