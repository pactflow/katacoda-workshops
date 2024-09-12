## Lets create some tests - Java

## Download the Java Demo Project


Lets go back to our root folder

👉🏼 `cd ~`{{exec}}

Clone our Java demo repo

👉🏼 `cd ~ && git clone https://github.com/pactflow/example-consumer-java-junit.git`{{exec}}

Change directory into our application

👉🏼 `cd example-consumer-java-junit`{{exec}}

This project already has an existing Pact test, you can run it.

It's located at `src/test/java/com/example/products/ProductsPactFlowTest.java`

👉🏼 `./gradlew clean test -i`{{exec}}

When run it will output a Pact file to `build/pacts`

👉🏼 `cat build/pacts/pactflow-example-consumer-java-junit-pactflow-example-provider-springboot.json | jq .`

## client-code

For some users, they do not have OpenAPI descriptions, for the providers the services rely on. `pactflow-ai` can generate Pact tests from
your client code, without the need for an OpenAPI description.

```sh
pactflow-ai generate code ./src/main/java/com/example/products/ProductClient.java \
  --output ./src/test/java/com/example/products/ProductsPactFlowAiTest.java \
  --language java
```{{exec}}

👉🏼 Check the generated Pact test at `src/test/java/com/example/products/ProductsPactFlowAiTest.java`

You can compare it with the existing test that was manually created `src/test/java/com/example/products/ProductsPactFlowTest.java` to compare

👉🏼 `./gradlew clean test -i`{{exec}}

You may need to tweak the output, and you'll note some assumptions are made.

1. The Product object model located as `src/main/java/com/example/products/Product.java` was not included with our client code when communicating with `pactflow-ai`. You can workaround this by inclining files before processing your tests. We will see further improvements in usage, and the context you can provide to `pactflow-ai`.

## Summary

You've now seen PactFlow AI generate Pact consumer tests, in 2 client languages. We look forward to bringing you further Pact DSL support in other languages such as Python / .NET & GoLang.

Hopefully we have powered your imagination, and we would love to know both how you get using using `pactflow-ai` today, and what you want to see in the future!

### Check

Before moving to the next step, check the following:

1. You have been able to run `pactflow-ai generate code` to generate a Pact-JVM test from client-code
1. You have been able to run `npm run test:pact` to execute the generated Pact tests
1. You have been able to generate a pact file in the `pacts` folder
