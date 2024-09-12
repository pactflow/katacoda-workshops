## Lets create some tests - JavaScript / TypeScript

1. `request-response`:
   1. Generate a Pact from a HTTP request and response pair from curl.
2. `openapi`:
   1. Generate a Pact from a OpenAPI specification
   2. Improve the output by providing it the client code.
3. `client-code`
   1. Generate Pact tests from client code.

## request-response

For some users, you may have an existing provider, that you wish to generate contracts for. `pactflow-ai` allows you to generate Pact tests from capture files. 

These capture files, are request/response pairs, from curl traffic.

You can see some sample captures, generated from requests to our running provider.

- Request Capture `capture/get.request.http`
- Response Capture `capture/get.response.http`

```
pactflow-ai generate request-response \
  --request ./capture/get.request.http \
  --response ./capture/get.response.http \
  --language typescript \
  --output ./src/api.pact.spec.ts
```{{exec}}

👉🏼 Check the generated file at `src/api.pact.spec.ts`

👉🏼 `npm run test:pact`{{exec}}

You may need to tweak the output, and you'll note some assumptions are made.

1. Your client code will not be used (it hasn't been provided)
2. The system under test is a client created purely for testing purposes, you would replace this with your actual client code.
3. We are using Jest in our project, and `pactflow-ai` prefers to use mocha based matchers, so I needed to change mocha's [to.deep.equal](https://www.chaijs.com/api/bdd/#method_deep) method to jest's[toEqual](https://jestjs.io/docs/expect#toequalvalue) method.

```js
expect(data).to.deep.equal({
  id: '10',
  name: 'Aussie',
  type: 'Pizza',
  version: 'v1',
  price: 9.99
});
```

```js
expect(data).toEqual({
  id: '10',
  name: 'Aussie',
  type: 'Pizza',
  version: 'v1',
  price: 9.99
});
```

Run your test again after your tweaks


👉🏼 `npm run test:pact`{{exec}}

If the test passes, you should have a Pact generated, in the `pacts` folder.

👉🏼 `cat pacts/*.json | jq .`{{exec}}

## openapi

For many users, you may have documented services using API descriptions that adhere to the OpenAPI specification.

These OpenAPI descriptions can aid shared understanding of a providing services expectations, for both providers and consumers.

For consumers, they can easily leverage tools like swagger-codegen to bootstrap clients from OpenAPI specifications in multiple languages.

Pact users have long requested the ability to generate Pact tests from OpenAPI descriptions, and with `pactflow-ai` this is now a possibility.

Lets leverage just an OpenAPI description, to generate a Pact consumer test.

```sh
pactflow-ai generate openapi \
--spec ./products.yml \
--endpoint "/product/{id}" \
--output ./src/api.pact.spec.ts \
--language typescript
```{{exec}}

👉🏼 Check the generated Pact test at `src/api.pact.spec.ts`

👉🏼 `npm run test:pact`{{exec}}

You may need to tweak the output, and you'll note some assumptions are made.

1. Your client code will not be used (it hasn't been provided)
2. A dummy client is substituted in place of your actual code. A user should replace this with their actual client.
  1. Try removing or commenting out the dummy client code and run the test
3. We are using Jest in our project, and `pactflow-ai` prefers to use mocha based matchers, so I needed to change mocha's [to.deep.equal](https://www.chaijs.com/api/bdd/#method_deep) method to jest's[toEqual](https://jestjs.io/docs/expect#toequalvalue) method.

👉🏼 `npm run test:pact`{{exec}}

The test should fail, as we are not issuing any client side request. Pact will show us in the console, the type of request we expected to receive.

You could try and integrate this test with your client code on your own, or you could use `pactflow-ai` to help you out.

## OpenAPI + client-code

In this example, we will use an OpenAPI description as an input, but will also provide the context of our client code, which will become our system under test.

By providing the context of our code, `pactflow-ai` can replace the dummy client generated in the previous step, with our real client. If your code also contains
the object model used, then `pactflow-ai` should ensure that only fields used by a consumer are added to the contract. This avoids a common pitfall test authors face,
whereby more fields are added to a consumer test, than the consumer client code uses. This puts tension between provider teams, as they are unduly bound to honour
those fields for consumers that do not use them.

```sh
pactflow-ai generate openapi \
  --spec ./products.yml \
  --endpoint "/product/{id}" \
  --code ./src/api.js \
  --output ./src/api.pact.spec.ts \
  --language typescript
```{{exec}}

👉🏼 Check the generated Pact test at `./src/api.pact.spec.ts`

👉🏼 `npm run test:pact`{{exec}}

You may need to tweak the output, and you'll note some assumptions are made.

1. We may need to change our product import from `./src/api` to `./api`
2. We are using Jest in our project, and `pactflow-ai` prefers to use mocha based matchers, so I needed to change mocha's [to.deep.equal](https://www.chaijs.com/api/bdd/#method_deep) method to jest's[toEqual](https://jestjs.io/docs/expect#toequalvalue) method.
3. Be sure to check expectations encoded into the Pact contract

👉🏼 `npm run test:pact`{{exec}}

When I ran my test, it failed.

```sh
2024-09-12T15:02:01.402663Z  INFO tokio-runtime-worker pact_mock_server::hyper_server: Request matched, sending response
 FAIL  src/api.pact.spec.ts
  Consumer Pact with Product Service
    Pact for getProductByID
      ✕ returns the requested product (41 ms)

  ● Consumer Pact with Product Service › Pact for getProductByID › returns the requested product

    expect(received).toEqual(expected) // deep equality

    - Expected  - 3
    + Received  + 1

    - Object {
    + Product {
        "id": "1234",
        "name": "Sample Product",
    -   "price": 42,
        "type": "food",
    -   "version": "1.0",
      }

      42 |         api.generateAuthToken = () => 'Bearer token'; // Mock the auth token generation
      43 |         const product = await api.getProduct('1234');
    > 44 |         expect(product).toEqual({
         |                         ^
      45 |           id: '1234',
      46 |           name: 'Sample Product',
      47 |           price: 42,

      at toEqual (src/api.pact.spec.ts:44:25)

Test Suites: 1 failed, 1 total
Tests:       1 failed, 1 total
Snapshots:   0 total
Time:        2.66 s, estimated 3 s
Ran all test suites.
```

This is because the Product Class, only contains three fields.

```js

export class Product {
  constructor({id, name, type}) {
    this.id = id
    this.name = name
    this.type = type
  }
}
```

It was incorrect, to have encoded the additional fields into our expected response, both in the Pact test and the assertion.

We should remove `version` & `price` from the `willRespondWith` method, and from our test assertion.

I've updated the test that was generated, and commented out the fields we don't require

```js
// Generated by PactFlow
// Timestamp: 2024-09-12T15:01:24.469001+00:00
// Reference: hpE1QhUuCzHKu625BbUh

import { PactV3, MatchersV3 } from "@pact-foundation/pact";
import { API } from "./api";

describe('Consumer Pact with Product Service', () => {
  const provider = new PactV3({
    consumer: 'ProductConsumer',
    provider: 'ProductService',
  });

  describe('Pact for getProductByID', () => {
    it('returns the requested product', () => {
      provider
        .given('Product with ID 1234 exists')
        .uponReceiving('a request to get a product by ID')
        .withRequest({
          method: 'GET',
          path: MatchersV3.regex('/product/\\d+', '/product/1234'),
          headers: {
            'Authorization': MatchersV3.regex('Bearer .*', 'Bearer token')
          }
        })
        .willRespondWith({
          status: 200,
          headers: {
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: MatchersV3.like({
            id: '1234',
            name: 'Sample Product',
            // price: 42,
            type: 'food',
            // version: '1.0'
          })
        });

      return provider.executeTest(async (mockserver) => {
        const api = new API(mockserver.url);
        api.generateAuthToken = () => 'Bearer token'; // Mock the auth token generation
        const product = await api.getProduct('1234');
        expect(product).toEqual({
          id: '1234',
          name: 'Sample Product',
          // price: 42,
          type: 'food',
          // version: '1.0'
        });
      });
    });
  });
});
```

Always be sure to validate your test for correctness. Hopefully time has been saved in creating the original test, and can be used in
ensuring the test is correct before you submit it to your team for review.

## client-code

For some users, they do not have OpenAPI descriptions, for the providers the services rely on. `pactflow-ai` can generate Pact tests from
your client code, without the need for an OpenAPI description.

```sh
pactflow-ai generate code ./src/api.js \
  --output ./src/api.pact.spec.ts \
  --language typescript
```{{exec}}

👉🏼 Check the generated Pact test at `src/api.pact.spec.ts`

👉🏼 `npm run test:pact`{{exec}}

You may need to tweak the output, and you'll note some assumptions are made.

1. We may need to change our product import from `./src/api` to `./api`
2. We are using Jest in our project, and `pactflow-ai` prefers to use mocha based matchers, so I needed to change mocha's [to.have.property](https://www.chaijs.com/api/bdd/#method_property) / [that.is.a](https://www.chaijs.com/api/bdd/#method_property) methods to jest's[toHaveProperty](https://jestjs.io/docs/expect#tohavepropertykeypath-value) / jest's[toBeInstanceOf](https://jestjs.io/docs/expect#tobeinstanceofclass) method.

👉🏼 `npm run test:pact`{{exec}}

## Summary

You've now seen the different options that PactFlow AI can provide, and how they can help you quickly generate consumer Pact tests.

Whilst they may need a small amount of tweaking to run, they quickly and accurately generate Pact tests, using the latest client library
DSL's, following recommend Pact best practices, including the usage of Provider States and Matchers. 

By refining the inputs you provide to PactFlow AI, hopefully you can find ways to tailor it to your particular use case.

You've now seen PactFlow AI generate Pact consumer tests. We look forward to bringing you further Pact DSL support in other languages such as Python / .NET & GoLang.

Hopefully we have powered your imagination, and we would love to know both how you get using using `pactflow-ai` today, and what you want to see in the future!

### Check

Before moving to the next step, check the following:

1. You have been able to run `pactflow-ai generate request-response` to generate a Pact test from a set of curl headers
1. You have been able to run `pactflow-ai generate openapi` to generate a Pact test from an OpenAPI Description
1. You have been able to run `pactflow-ai generate code` to generate a Pact test from client-code
1. You have been able to run `pactflow-ai generate openapi` to generate a Pact test from an OpenAPI Description enhanced by client-code
1. You have been able to run `npm run test:pact` to execute the generated Pact tests
1. You have been able to generate a pact file in the `pacts` folder

<--- In our next step, we will look at similar scenario with a Java application. --->