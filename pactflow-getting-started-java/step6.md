# Testing (Verify) the provider

Now that we published our contract, we can have the provider verify it each time the provider build runs, to prevent introducing breaking changes to their consumers. This is referred to as "provider verification".

_NOTE: Credentials from the previous step will be required for this step to run._

#### Run the Provider tests

This step involves the following:

1. Importing the Pact, JUnit and Spring dependencies
1. Starting the spring boot application - the API - using the `@SpringBootTest` annotation
1. Configuring Pact to use the contracts stored in Pactflow
1. Configuring Pact to test the API running at `http://localhost:8080`
1. Executing the provider verification
1. Handling any provider states

Let's look at our Provider pact test `/root/example-provider-springboot/src/test/java/com/example/springboot/ProductsPactTest.java`{{copy}}

1. Ensure the `editor` tab is open
2. Click on a filename(s) above to copy it
3. Click into the editor window and press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

```
package com.example.springboot;

// (1) Pact JUnit specific imports
import au.com.dius.pact.provider.junitsupport.*;
import au.com.dius.pact.provider.junitsupport.loader.*;
import au.com.dius.pact.provider.junit5.HttpTestTarget;
import au.com.dius.pact.provider.junit5.PactVerificationContext;
import au.com.dius.pact.provider.junit5.PactVerificationInvocationContextProvider;

import java.io.IOException;

// (1) Junit imports
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.TestTemplate;
import org.junit.jupiter.api.extension.ExtendWith;

// (1) Spring context
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;

// (2)
@ExtendWith(SpringExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT)
// (3)
@Provider("pactflow-example-provider-springboot")
@PactBroker(scheme = "https", host = "${PACT_BROKER_HOST}", providerBranch = "${GIT_COMMIT}", enablePendingPacts = "true", authentication = @PactBrokerAuth(token = "${PACT_BROKER_TOKEN}"))
class ProductsPactTest {

  @Autowired
  ProductRepository repository;

  // (4)
  @BeforeEach
  public void setupTestTarget(PactVerificationContext context) {
    context.setTarget(new HttpTestTarget("localhost", 8080));
  }

  // (5)
  @TestTemplate
  @ExtendWith(PactVerificationInvocationContextProvider.class)
  public void pactVerificationTestTemplate(PactVerificationContext context) {
    context.verifyInteraction();
  }

  // (6)
  @State("a product with ID 10 exists")
  public void setupProductX010000021() throws IOException {
    System.out.println("a product with ID 10 exists");
    repository.save(new Product(10L, "test", "product description", "1.0.0"));
  }
  ...
}
```

We choose which contracts to select with consumer version selectors
   1. Read more about [consumer version selectors](https://docs.pact.io/pact_broker/advanced_topics/consumer_version_selectors)
   2. See the [Recommended configuration for verifying pacts
      ](https://docs.pact.io/provider/recommended_configuration)

See `build.gradle` where we set [system properties](https://docs.pact.io/implementation_guides/jvm/docs/system-properties), such as consumerversionselectors

```
test {
	useJUnitPlatform()

	// These properties need to be set on the test JVM process
	systemProperty("pact.provider.version", System.getenv("GIT_COMMIT") == null ? "" : System.getenv("GIT_COMMIT"))
	systemProperty("pact.provider.tag", System.getenv("GIT_BRANCH") == null ? "" : System.getenv("GIT_BRANCH"))
	systemProperty("pact.provider.branch", System.getenv("GIT_BRANCH") == null ? "" : System.getenv("GIT_BRANCH"))
	systemProperty("pactbroker.consumerversionselectors.rawjson", "[{\"mainBranch\":true}]")
	systemProperty("pact.verifier.publishResults", System.getenv("PACT_BROKER_PUBLISH_VERIFICATION_RESULTS") == null ? "false" : "true")
}
```

Run the test: `./gradlew clean test`{{execute}}

## Check

Your dashboard should look something like this, showing the pact as verified (you can ignore any tags applied for now).

![pactflow-dashboard-provider-verifier](./assets/pactflow-dashboard-provider-verified-prod.png)
