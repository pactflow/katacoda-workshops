## Testing the consumer

Now that we have our basic consumer code base, it's time to write our first Pact test! We'll be using JUnit 5 for this task.

Pact implements a specific type of integration test called a contract test. Martin Fowler defines it as follows:

> An integration contract test is a test at the boundary of an external service verifying that it meets the contract expected by a consuming service — [Martin Fowler](https://martinfowler.com/bliki/IntegrationContractTest.html)

Open the pact test: `example-consumer-java-junit/src/test/java/com/example/products/ProductsPactTest.java`{{copy}}

1. Click the filename above to copy.
2. Ensure the `editor` tab is open
3. press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

```
package com.example.products;

// (1) Pact dependencies
import au.com.dius.pact.consumer.MockServer;
import au.com.dius.pact.core.model.RequestResponsePact;
import au.com.dius.pact.core.model.annotations.Pact;
import au.com.dius.pact.consumer.dsl.PactDslJsonArray;
import au.com.dius.pact.consumer.dsl.PactDslJsonBody;
import au.com.dius.pact.consumer.dsl.PactDslWithProvider;
import au.com.dius.pact.consumer.junit5.PactConsumerTestExt;
import au.com.dius.pact.consumer.junit5.PactTestFor;

// (1) JUnit extension imports
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.api.Test;

// (1) Unit test matchers (not Pact specific)
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

import java.io.IOException;
import java.util.List;

// (2) JUnit annotations
@ExtendWith(PactConsumerTestExt.class)
@PactTestFor(providerName = "pactflow-example-provider-springboot")
public class ProductsPactTest {

  // (3) Arrange
  @Pact(consumer="pactflow-example-consumer-java-junit")
  public RequestResponsePact getProduct(PactDslWithProvider builder) {
    PactDslJsonBody body = new PactDslJsonBody();
    body.stringType("name", "product name");
    body.stringType("type", "product series");
    body.stringType("id", "5cc989d0-d800-434c-b4bb-b1268499e850");

      return builder
        .given("a product with ID 10 exists")
        .uponReceiving("a request to get a product")
          .path("/product/10")
          .method("GET")
        .willRespondWith()
          .status(200)
          .body(body)
        .toPact();
    }

  // (4) Act
  @PactTestFor(pactMethod = "getProduct")
  @Test
  public void testGetProduct(MockServer mockServer) throws IOException {
    // (4) Act
    Product product = new ProductClient().setUrl(mockServer.getUrl()).getProduct("10");

    // (5) Assert that we got the expected response
    assertThat(product.getId(), is("5cc989d0-d800-434c-b4bb-b1268499e850"));
  }

  ...
}
```

There's a lot here, so let's break it down a little.

Steps `1`, `2` are Java specific activities to get Pact into a project, including the dependencies and JUnit configuration.

Steps `3`, `4` and `5` follow the [3A's (Arrange/Act/Assert) pattern](https://docs.microsoft.com/en-us/visualstudio/test/unit-test-basics?view=vs-2019#write-your-tests) for authoring unit tests.

1. Import the appropriate library - this will differ depending on language
2. Configure Pact. The name of the provider is important, as it uniquely identifies the applications in Pactflow
3. _Arrange_: here we setup a Pact lifecycle hook that is responsible for configuring the Pact provider mock service, specifically for the `getProduct` interaction. We tell Pact what we're expecting our code to do and what we expect the provider to return when we do it. The Act and Assert phases will be part of a separate method that Pact knows how to invoke using the `PactTestFor` annotation.
4. _Act_: we configure our API client to send requests to the Pact mock service (instead of the real provider) and we execute the call to the API
5. _Assert_: we check that our call to `getProduct(...)` worked as expected. This should just do what a regular unit test of this method would do.

### Run the test

`./gradlew clean test`{{execute}}

It should have created the following file:

`cat /root/example-consumer-java-junit/build/pacts/pactflow-example-consumer-java-junit-pactflow-example-provider-springboot.json | jq .`{{execute}}

### Check

Before moving to the next step, check the following:

1. You could run the pact test with `./gradlew clean test`{{execute}}
1. There is a contract file that has been created at `/root/example-consumer-java-junit/build/pacts/pactflow-example-consumer-java-junit-pactflow-example-provider-springboot.json`
   1. You can see this in your editor by running `cat /root/example-consumer-java-junit/build/pacts/pactflow-example-consumer-java-junit-pactflow-example-provider-springboot.json | jq .`{{execute}}
   2. Or you can click the Editor tab and search for the file with `command+p` or `ctrl+p`

### References

- https://docs.pact.io/implementation_guides/jvm/provider/junit5/
