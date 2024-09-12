## Setup

PactFlow AI currently allows for consumer side HTTP Pact contract test creation, via three types of modes

1. `request-response`:
   1. Generate a Pact from a HTTP request and response pair from curl.
2. `openapi`:
   1. Generate a Pact from a OpenAPI specification
   2. Improve the output by providing it the client code.
3. `client-code`
   1. Generate Pact tests from client code.

In all cases, in order to successfully execute the tests, and generate Pact contracts from them, you will need
to exercise the tests against an actual consumer codebase.

You may be able to create a standalone Pact test, without client code, but we would expect this test to fail as
no client code would be available, and therefore Pact would inform the user that the expected request was not made.

## Language Support

At launch, PactFlow AI will support the following programming languages

- Java
- TypeScript

We have created sample codebases, for each language, in order to use as the base for our tutorial, and save you having
to write your own client code in this demo.

### TypeScript Demo

- [Consumer](https://github.com/mefellows/example-consumer/tree/demo)
<!-- - [Consumer](https://github.com/pactflow/example-consumer) -->
- [Provider](https://github.com/pactflow/example-provider)

<!--- ### Java Demo

- [Consumer](https://github.com/pactflow/example-consumer-java-junit)
- [Provider](https://github.com/pactflow/example-provider-springboot)
- --->


## Grab the TypeScript example

Clone the repo

👉🏼 `git clone https://github.com/mefellows/example-consumer.git --branch demo`{{exec}}

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
