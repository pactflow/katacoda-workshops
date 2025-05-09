## Setup

PactFlow AI allows for consumer side HTTP Pact contract test creation, via three sources:

1. `request-response`:
   1. Generate a pact from a HTTP request and response pair from [HTTP Messages](https://developer.mozilla.org/en-US/docs/Web/HTTP/Messages) (e.g. `curl` output).
2. `openapi`:
   1. Generate a pact from a OpenAPI description.
   2. Improve the output by providing it the client code.
3. `client-code`
   1. Generate pact tests from client code.

In all cases, to successfully execute the tests, and generate Pact contracts from them, you will need to exercise the tests against an actual consumer codebase.

You may be able to create a standalone Pact test, without client code, but we would expect this test to fail as no client code would be available, and therefore Pact would inform the user that the expected request was not made.

## Language Support

PactFlow currently supports the following programming languages

- Java
- TypeScript

*(Refer to the [docs](https://docs.pactflow.io/docs/ai) for the most up-to-date list of supported languages)*.

We have created sample codebases, for each language, in order to use as the base for our tutorial, and save you having
to write your own client code in this demo.

### TypeScript Demo

- [Consumer](https://github.com/pactflow/example-consumer)

## Grab the TypeScript example

Clone the repo

👉🏼 `git clone https://github.com/pactflow/example-consumer.git --branch ai`{{exec}}

Change into the newly cloned repo directory

👉🏼 `cd example-consumer`{{exec}}

Install the projects dependencies

👉🏼 `npm install`{{exec}}

Feel free to browse the project. You will find our API client at

`src/api.js`

### Check

Before moving to the next step, check the following:

1. There is a directory called `example-consumer` in your workspace.
2. You've been able to install the projects dependencies.
