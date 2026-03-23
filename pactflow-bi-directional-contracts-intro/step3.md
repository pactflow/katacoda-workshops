# Testing the provider

Now that we have our working Provider, we need to do two things to prevent introducing breaking changes to our consumers.

1. Ensure the API doesn't drift from it's OpenAPI description document (OAS)
2. Ensure the OAS doesn't change such that it could break any of its consumers

Right now, we don't have any consumers, but we want to be prepared for when we do.

For (1), we need to decide on our testing approach.
For (2), we'll use PactFlow's contract comparison capability to prevent breaking changes, which we cover in Step 5.

### Verifying the provider contract

There are severals ways we can test the Provider, to ensure it doesn't drift from the OAS. This process is referred to as _verifying the provider contract_.

1. Generate the OAS from code. This is the most reliable, because whenever the implementation changes, the OAS will change with it. Tools like Spring Docs (Java) and Swashbuckle (.NET) will do this for you.
1. White-box style tests that run as part of your unit tests. Tools such as RestAssured (Java) or Supertest (NodeJS) are examples of these.
1. Black-box style functional API testing, using tools like Drift, Dredd or Postman.

In our case, (1) is not acceptable as we've chosen to following design first approach. We decided to use (3), using a tool called Drift. Drift will read in our OAS, and issue HTTP calls to our locally running provider to ensure it's compatible with the spec.

### Understanding API Drift

API Drift occurs when your API's implementation—the actual code—no longer matches its specification (the OpenAPI file).

#### The Problem

As APIs evolve, developers might add fields, change data types, or modify status codes. If the documentation isn't updated simultaneously, client applications relying on that spec will break.

#### The Drift Solution

Project Drift is a spec-first testing tool. It ensures alignment through three core mechanisms:

- Specification as Source of Truth: Tests are mapped directly to your OpenAPI endpoints.
- Deep Schema Validation: Drift automatically validates response bodies against the JSON schemas defined in your spec.
- Repeatable CI/CD Validation: By running Drift in your automation pipeline, you catch drift before it reaches production.

#### Why this matters

Teams often want confidence that their API “works correctly”, but this can refer to many different concerns:

1. Does the API conform to its contract?
1. Does the system behave correctly when the API is exercised?
1. Do multi-step workflows work as expected?
1. Do downstream systems respond correctly?

Drift rigorously addresses #1. Functional, integration, and E2E tests address #2–4.

This distinction is essential for establishing a stable, maintainable testing strategy.

### What Drift Is Designed to Test

Drift performs **contract conformance testing** — fast, deterministic checks that validate whether an API implementation matches its published specification.

Drift validates:

- request/response structure
- status codes
- headers and media types
- JSON schema conformance
- examples from the OpenAPI document
- path, query, and header parameter constraints
- **narrow, controlled statefulness** (e.g., verifying 200 vs 404 for known IDs)

Drift supports limited, operation‑scoped stateful testing where the state is **local, controlled, and does not depend on earlier test execution**. See: [Testing APIs With State Dependencies](https://pactflow.github.io/drift-docs/docs/tutorials/testing-with-state)

These checks are fast, isolated, and highly repeatable — ideal for local development, CI pipelines, and production validation.

### What Drift Is Not Designed to Test

Drift does not validate broader system behaviour, including:

- multi-step workflows requiring prior operations
- scenario sequencing (“set system state then test”)
- business rules or domain logic
- system‑wide side effects (DB updates, events, queues)
- cross-service or distributed behaviours

These concerns belong to functional, integration, or E2E testing.

### Getting Started 

#### Install Drift

Drift is available as a standalone binary, and is language agnostic. It can be used to test any API, regardless of the implementation language or framework.

**Note: if npm or npx is not available in your tutorial shell, run `source /root/.bashrc`{{execute}} to load nvm (node version manager).**

The simplest way to try Drift without installing anything globally is with `npx` (requires node):

`npx -y @pactflow/drift --help`{{execute}}

If you prefer a global install (available across shells), install from npm, please do so, for this tutorial

`npm install -g @pactflow/drift`{{execute}}

`drift --help`{{execute}}

If you don't use node, or need more options, see our [Installation Guide](https://pactflow.github.io/drift-docs/docs/how-to/install) for manual installation, verification steps, and troubleshooting.

#### Authenticate Drift with PactFlow

Drift authenticates with PactFlow to validate your licence and download provider configurations. This is separate from authenticating to the API you are testing.

Obtain your API token from **Settings → API Tokens** in your PactFlow workspace.

The recommended way to authenticate is with the `drift auth` command, lets check the status of our authentication with PactFlow:

👉 `drift auth status`{{execute}}

Drift prompts you for your PactFlow workspace URL and API token, then exchanges them for a session token cached locally for 7 days:

```
PactFlow URL: https://your-workspace.pactflow.io
PactFlow token:
Authenticated as Jane Smith <jane.smith@example.com>  (expires 2026-03-26 00:36:28 UTC)
```

### Authenticating with environment variables

Alternatively, set your credentials as environment variables before running `drift auth`. Drift reads these automatically to create the token:

```bash
export PACT_BROKER_BASE_URL="https://your-workspace.pactflow.io"
export PACT_BROKER_TOKEN="your-api-token"
```

Obtain your API token from **Settings → API Tokens** in your PactFlow workspace.

Select `Copy Token Value` -> `as Environment Variables` to get the correct export command for your shell, if using Linux or MacOS. For Windows, choose `Windows` for command prompt or `PowerShell` for PowerShell.

This is the recommended approach for CI/CD pipelines where interactive login is not available.

Once you have set you tokens, you can login with:

👉 `drift auth login`{{execute}}

and verify the status with:

👉 `drift auth status`{{execute}}

#### Create your First Test Suite

Create a file named `drift.yaml` in the `example-bi-directional-provider-drift` folder. We will point Drift to the Petstore OpenAPI definition and define a few simple operations to verify.

```
# yaml-language-server: $schema=https://download.pactflow.io/drift/schemas/drift.testcases.v1.schema.json
drift-testcase-file: v1
title: "Petstore API Verification"

sources:
  - name: petstore-oas
    # Use the remote Petstore API description
    uri: https://petstore3.swagger.io/api/v3/openapi.yaml
    # Or a local one
    # path: oad.yaml

plugins:
  - name: oas
  - name: json

operations:
  # Verify that the inventory can be retrieved
  getInventory_Success:
    target: petstore-oas:getInventory
    description: "Check if store inventory is accessible"
    expected:
      response:
        statusCode: 200

  # Verify fetching a pet by a specific ID
  getPetById_Success:
    target: petstore-oas:getPetById
    description: "Fetch details for pet ID 1"
    parameters:
      path:
        petId: 1
    expected:
      response:
        statusCode: 200

  # Verify fetching a pet by a specific ID
  getPetById_NotFound:
    target: petstore-oas:getPetById
    description: "Fetch details for pet ID 143"
    parameters:
      path:
        petId: 143
    expected:
      response:
        statusCode: 404
```{{copy}}


💡 __IDE Tip: The YAML Language Server comment at the top enables auto-completion and validation in your editor. As you type, you'll see suggestions for property names and valid values.__

#### Run the Verifier

Run the drift verify command. We will use the Petstore virtual server (https://petstore.swagger.io/v2/) as our target URL.

`cd /root/example-bi-directional-provider-drift`{{execute}}

`drift verify --test-files drift.yaml --server-url https://petstore.swagger.io/v2/`{{execute}}

#### Viewing Test Results

Drift displays results in a clear table format:

```
─[ Summary ]───────────────────────────────────────────────────────────────────────────────────────────

Executed 1 test case (1 passed, 0 failed)
Executed 3 operations (3 passed, 0 failed, 0 skipped)
Execution time 1.288865209s
Setup time 72.192458ms

┌────────────────────────────┬────────────────────────────┬──────────────────────────────────┬────────┐
│ Testcase                   ┆ Operation                  ┆ Target                           ┆ Result │
╞════════════════════════════╪════════════════════════════╪══════════════════════════════════╪════════╡
│ Petstore API Test          ┆ getInventory_Success       ┆ petstore-oas:getInventory        ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌-┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌-╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌---╌╌╌┼╌╌╌╌╌╌╌╌┤
│                            ┆ getPetById_Success         ┆ petstore-oas:getPetById          ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌-╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌-╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌--╌╌╌┼╌╌╌╌╌╌╌╌┤
│                            ┆ getPetById_NotFound        ┆ petstore-oas:getPetById          ┆ OK     │
└────────────────────────────┴────────────────────────────┴──────────────────────────────────┴────────┘
```

Each row shows an operation, its target, and the result (OK or FAILED). The summary at the top tells you how many test cases and operations passed.

If a test fails, you'll see a Failures section with details about what went wrong. See [Debugging](https://pactflow.github.io/drift-docs/docs/how-to/debugging) for how to interpret and fix failures.

#### What Happened Behind the Scenes

1. Source Loading: Drift fetched the `oas.yaml` from the remote URL.
1. Contract Mapping: It mapped your `getInventory_Success` operation to the `/store/inventory` endpoint in the spec.
1. Deep Validation: Drift executed the HTTP request and performed a full JSON schema validation on the response to ensure it matches the `Petstore` model.

### Create and Run Tests for the Product API

Lets test our actual Product API implementation using Drift. We will create a test suite that verifies the API implementation against the OAS document we created in Step 2.

When using a black-box style tool, the testing involves the following steps:

1. Preparing data so that all of the OAS scenarios may be tested
2. Configuring the tool to read in the OAS and discover the provider
3. Starting the API locally, stubbing out downstream dependencies where possible
4. Running the tool
5. Capturing the output

#### Define the Test Suite

Here is the Drift test suite we have created for our Product API, with some properties removed for clarity, the test suite contains 3 operations, one for each endpoint in our API.

1. Ensure the `editor` tab is open
2. Click on a filename(s) below to copy it
3. Click into the editor window and press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

`example-bi-directional-provider-drift/drift/drift.yaml`{{copy}}

The version of the drift-testcase-file schema we are using is v1, which is the latest version at the time of writing. You can find the latest version of the schema here: https://download.pactflow.io/drift/schemas/drift.testcases.v1.schema.json

```
# yaml-language-server: $schema=https://download.pactflow.io/drift/schemas/drift.testcases.v1.schema.json
drift-testcase-file: v1
```

The drift test suite title

```
title: "Product API Tests"
```

The sources of our input specifications, datasets (from granular test data control) and any custom functions.

```
sources:
  - name: source-oas
    path: ../openapi.yaml
  - name: product-data
    path: product.dataset.yaml
  - name: functions
    path: product.lua
```

The types of plugins we want to use

```
plugins:
  - name: oas
  - name: json
  - name: data
  - name: http-dump
  - name: junit-output
```

Any global configuration for the test suite

```
global:
  auth:
    apply: true
    parameters:
      authentication:
        scheme: bearer
        token: ${functions:bearer_token} # Example using function to generate token value dynamically at runtime
        # token: ${env:BEARER_TOKEN}       # Example of using environment variable for token value, which can be set in CI/CD pipeline or locally for testing
```

We can then write test cases for each operation in our API. Here is the happy path test case for the `GET /products` endpoint:

```
operations:
  # GIVEN a valid bearer token
  # WHEN getting all products
  # THEN expect 200 OK response with product array
  getAllProducts_Success:
    target: source-oas:getAllProducts
    description: "Get all products successfully"
    expected:
      response:
        statusCode: 200
```

Here is an unhappy path test case, where the provided authentication token is invalid:

```
  # GIVEN an invalid bearer token
  # WHEN getting all products
  # THEN expect 401 Unauthorized response
  getAllProducts_Unauthorized:
    target: source-oas:getAllProducts
    description: "Get all products with invalid authorization"
    exclude:
      - auth
    parameters:
      headers:
        authorization: "Bearer invalid-token"
    expected:
      response:
        statusCode: 401
```

#### View the Provider test setup

Our javascript test script will programmatically start our server, and the drift API testing tool, which will then issue requests and assert on responses to our locally running provider at `http://127.0.0.1:8080`.

View the file at `example-bi-directional-provider-drift/src/product/api-inmemory.test.js`{{copy}} to see how this is implemented.

We spawn drift as a child process, and await its completion. Once drift has completed, we can capture the exit code and assert that it is 0, which indicates all tests passed.

```js
// Set repository type for this test suite
process.env.REPOSITORY_TYPE = 'inmemory';

const { runDrift } = require('../../automation/drift');
const controller = require('./product.controller');
const bodyParser = require('body-parser');

// Setup provider server to verify
const app = require('express')();
const authMiddleware = require('../middleware/auth.middleware');
app.use(bodyParser.json());
app.use(authMiddleware);
app.use(require('./product.routes'));
app.use(require('../../automation/test.routes')); // Test only routes for setting up test state
const server = app.listen("8080");

describe("API Tests with Drift", () => {
  // Ensure server and pg connection are closed
  afterAll(async () => {
    await new Promise((resolve) => server.close(resolve));
    const repo = controller.getRepository();
    if (repo && typeof repo.close === 'function') {
      await repo.close();
    }
  });

  it("Validates the API comforms to its OpenAPI Description", async () => {
    const exitCode = await runDrift();
    expect(exitCode).toBe(0);
  })
});
```

## Execute the tests

Now we can run the tests:

1. `cd /root/example-bi-directional-provider-drift`{{execute}}
2. `npm run test:inmemory`{{execute}}

Your output should look like this:

```
$ npm run test:inmemory

> product-service@1.0.0 test:inmemory
> NODE_ENV=test npx jest --colors --testTimeout 30000 --testMatch "**/api-inmemory.test.js"

  console.log
    create {
      id: 666,
      name: 'cola',
      price: 10.99,
      type: 'beverage',
      version: '1.0.0'
    }

      at Object.<anonymous>.exports.create (src/product/product.controller.js:39:13)

  console.log
    create {
      id: 666,
      name: 'cola',
      price: 10.99,
      type: 'beverage',
      version: '1.0.0'
    }

      at Object.<anonymous>.exports.create (src/product/product.controller.js:39:13)

  console.log
    getAll

      at Object.<anonymous>.exports.getAll (src/product/product.controller.js:22:13)

  console.log
    getById invalid

      at Object.<anonymous>.exports.getById (src/product/product.controller.js:28:13)

  console.log
    getById 99999

      at Object.<anonymous>.exports.getById (src/product/product.controller.js:28:13)

  console.log
    getById 10

      at Object.<anonymous>.exports.getById (src/product/product.controller.js:28:13)


 RUNS  src/product/api-inmemory.test.js

─[ Summary ]───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Executed 1 test case (1 passed, 0 failed)
Executed 9 operations (9 passed, 0 failed, 0 skipped)
Execution time 950.30575ms
Setup time 9.108ms

┌───────────────────┬──────────────────────────────────┬───────────────────────────┬────────┐
│ Testcase          ┆ Operation                        ┆ Target                    ┆ Result │
╞═══════════════════╪══════════════════════════════════╪═══════════════════════════╪════════╡
│ Product API Tests ┆ createProduct_Success            ┆ source-oas:createProduct  ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ createProduct_SuccessWithExample ┆ source-oas:createProduct  ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ createProduct_Unauthorized       ┆ source-oas:createProduct  ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getAllProducts_Success           ┆ source-oas:getAllProducts ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getAllProducts_Unauthorized      ┆ source-oas:getAllProducts ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getProductByID_InvalidID         ┆ source-oas:getProductByID ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getProductByID_NotFound          ┆ source-oas:getProductByID ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getProductByID_Success           ┆ source-oas:getProductByID ┆ OK     │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┤
│                   ┆ getProductByID_Unauthorized      ┆ source-oas:getProductByID ┆ OK     │
 PASS  src/product/api-inmemory.test.js────────────────┴───────────────────────────┴────────┘
  API Tests with Drift
    ✓ Validates the API comforms to its OpenAPI Description (3108 ms)

Test Suites: 1 passed, 1 total
Tests:       1 passed, 1 total
Snapshots:   0 total
Time:        3.424 s, estimated 31 s
Ran all test suites.
```

As you can see, Drift has issued calls to all 3 endpoints, each with multiple variations, and the tests are ✅.

## Before you move on

1. `drift`{{execute}} should be globally installed, if not, ensure you have installed it correctly using `npm install -g @pactflow/drift`{{execute}}
2. There are verification results `ls -la /root/example-bi-directional-provider-drift/output/results/verification.*.result`{{execute}} for the test run
