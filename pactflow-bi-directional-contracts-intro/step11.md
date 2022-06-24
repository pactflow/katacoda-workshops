If you've made it this far, you should now have a good understanding of how Pactflow's bi-directional contract testinsg feature works to make it safe to release software into production quickly and reliably.

## Summary

### Consumer Contracts

Pactflow currently supports pact files as a consumer contract format. In order to produce a consumer contract, you need to decide on a testing approach to capture the contract:

1. Use [Pact](http://docs.pact.io) - this will be the default choice for many, as it can both mock the API calls and produce a pact file
2. Use an existing mocking tools such as Wiremock or Mountebank, or record/replay tools (such as VCR or Polly), and convert the mocks to a pact file after a successful run.

[Read more](https://docs.pactflow.io/docs/bi-directional-contract-testing/contracts/pact#strategies-to-capture-consumer-contracts) on these strategies.

### Provider Contracts

Pactflow currently supports oas(OpenAPI) spec files as a provider contract formats along with provider verification results. In order to produce a provider contract, you need to decide on a testing approach to capture the spec and verification results to form the provider contract:

#### Verifying the provider contract

- Ensure the API doesn't drift from it's OpenAPI description document (OAS)
- Ensure the OAS doesn't change such that it could break any of its consumers

There are severals ways we can test the Provider, to ensure it doesn't drift from the OAS. This process is referred to as verifying the provider contract.

1. Generate the OAS from code. This is the most reliable, because whenever the implementation changes, the OAS will change with it. Tools like Spring Docs (Java) and Swashbuckle (.NET) will do this for you.
1. White-box style tests that run as part of your unit tests. Tools such as 1. 1.1. RestAssured (Java) or Supertest (NodeJS) are examples of
   Black-box style functional API testing, using tools like Dredd or Postman.

### How Pactflow protects your teams

Pactflow will prevent a consumer from deploying a change that a Provider has yet to support

1. It is always safe to remove a field from a provider, if no consumers are currently using it
1. It is not safe to remove a field/endpoint from a provider, if an existing consumer is using it, and Pactflow will detect this situation.

## Further material

You may be interested in one of our longer form [workshops](https://docs.pact.io/implementation_guides/workshops), or getting deeper into [CI/CD](https://docs.pactflow.io/docs/workshops/ci-cd/) with Pact.

### Bi-directional Contract Testing resources

This is a Pactflow-only feature currently available on all plans that will enable your teams to supercharge your existing testing tools to perform both consumer-driven and provider-driven contract tests.

- Bi-directional Contract Testing [Overview](https://pactflow.io/bi-directional-contract-testing/)
- [Video introducing](https://youtu.be/8_abWl1N32Q) to Bi-Directional Contract Testing
- Video for Bi-Directional Contract Testing: [What is it and how it works](https://youtu.be/9qZN7wHEQ1U)
- Examples [projects](https://docs.pactflow.io/docs/examples) such as Dredd, RestAssured, Cypress, MSW, Wiremock and more
- A [useful blog](https://pactflow.io/blog/bi-directional-contracts/) on Bi-directional Contract Testing

### Pact resources

You’ll find our educational resources helpful to get you started with Pact:

- Our introduction to contract testing [videos](https://www.youtube.com/playlist?list=PLwy9Bnco-IpfZ72VQ7hce8GicVZs7nm0i&utm_source=hubspot&utm_medium=email&utm_campaign=demo)
- Getting started [tutorials](https://docs.pactflow.io/docs/tutorials) - short (15 minute) in-browser exercises to get started with Pact and Pactflow
- [Pactflow University](https://docs.pactflow.io/docs/workshops/) - our introduction and CI/CD workshops, as well as some advanced material
- [Examples](https://docs.pactflow.io/docs/examples/) - a series of reference examples across languages and technologies
