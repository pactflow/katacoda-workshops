
## Passing Additional Prompts

When generating code, you can specify additional instructions for PactFlow AI to use to customize the output. For example, you might wish to provide extra guidelines or configurations, useful for handling special cases, overriding default behaviors, or adding constraints to the generation logic for a specific test.

To customize the output with prompts, use the `--instructions` parameter.

Instructions can be provided as a direct string or read from a local file.

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

Alternatively, you can load instructions from a file `--instructions /path/to/instructions.txt`

This would instruct the test generation process to read the file content and use it as the instruction.

You can try this now.

`prompts.txt`:

```md
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
  --instructions ./prompts.txt
```{{exec}}

## Execute the test

👉🏼 `npm run test:pact`{{exec}}


### Check

1. You have been able generate a test using PactFlow AI with the `--instructions` flag and some text on the command line to customize the output.
2. You have been able generate a test using PactFlow AI with the `--instructions` flag and a path for a prompt file containing one or many prompts to customize the output.
