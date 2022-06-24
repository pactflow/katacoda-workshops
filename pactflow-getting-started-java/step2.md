## The Consumer

Time to create our consumer code base. Your terminal should currently be cloning the following repository: https://github.com/pactflow/example-consumer-java-junit

In our project, we're going to need:

- A model (the `Product` class) to represent the data returned from the Product API
- A client (the `ProductClient`) which will be responsible for making the HTTP calls to the Product API and returning an internal representation of an Product.

To be able to create a Pact test, you _do_ need to write the code that executes the HTTP requests to your service (in your client class), but you don't need to write the full stack of consumer code (eg. the UI). That is to say, you can start writing Pact tests before all of your consumer code is ready.

_NOTE_: We'll be running the following commands from the sub-project in `/root/example-consumer-java-junit`, and your terminal should already be in this directory, if not try `cd /root/example-consumer-java-junit`{}

### Scope of a Consumer Pact Test

Ideally, the Pact tests should be a unit test for your API client class, and they should just focus on ensuring that the request creation and response handling are correct. If you use pact for your UI tests, you'll end up with an explosion of redundant interactions that will make the verification process tedious. Remember that pact is for testing the contract used for communication, and not for testing particular UI behaviour or business logic.

Usually, your application will be broken down into a number of sub-components, depending on what type of application your consumer is \(e.g. a Web application or another API\). This is how you might visualise the coverage of a consumer Pact test:

![Scope of a consumer Pact test](./assets/consumer-test-coverage.png)

Here, a _Collaborator_ is a component whose job is to communicate with another system. In our case, this is the `API` class communicating with the external `Product API` system. This is what we want our consumer test to inspect.

### Create a new Project

We are going to be using Gradle as our build system, however you are free to use whatever build tool that you prefer (we support several other tools such as Maven and SBT). Open up the file `example-consumer-java-junit/build.gradle`{{copy}}

1. Click the filename above to copy.
2. Ensure the `editor` tab is open
3. press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list to look at the dependencies needed for our project.

```
plugins {
	id 'org.springframework.boot' version '2.2.2.RELEASE'
	id 'io.spring.dependency-management' version '1.0.8.RELEASE'
	id 'java'
  id "au.com.dius.pact" version "4.1.0"
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '11'

repositories {
	mavenCentral()
}

configurations {
  compileOnly {
    extendsFrom annotationProcessor
  }
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-web'
	implementation "org.apache.httpcomponents:fluent-hc:4.5.5"
	testCompile 'au.com.dius:pact-jvm-consumer-junit5:4.0.10'

  compileOnly 'org.projectlombok:lombok'
  annotationProcessor 'org.projectlombok:lombok'
	testImplementation('org.springframework.boot:spring-boot-starter-test') {
		exclude group: 'org.junit.vintage', module: 'junit-vintage-engine'
	}
}

test {
	useJUnitPlatform()
}
```

Install dependencies for the project by running `./gradlew`{{execute}}

(click on the highlighted command above to run `./gradlew` automatically in the terminal window to the right. Again, look out for these as we progress through the workshop)

### Create our Product Model

Now that we have our build system in place, let's create our `Product` domain model:

`example-consumer-java-junit/src/main/java/com/example/products/Product.java`{{copy}}

1. Click the filename above to copy.
2. Ensure the `editor` tab is open
3. press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

```
@Data
class Product {
  @JsonFormat( shape = JsonFormat.Shape.STRING)
  private String id;
  private String name;
  private String type;

  Product() {}

  Product(String id, String name, String type) {
    this.id = id;
    this.name = name;
    this.type = type;
  }
}
```

### Create our Product API Client

Lastly, here is our (abbreviated) API client code. This code is responsible for fetching products from the API, returning a `Product`:

`example-consumer-java-junit/src/main/java/com/example/products/ProductClient.java`{{copy}}

1. Click the filename above to copy.
2. Ensure the `editor` tab is open
3. press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

```
public class ProductClient {
  private String url;

  public ProductClient setUrl(String url) {
    this.url = url;
    return this;
  }

  public Product getProduct(String id) throws IOException {
    return (Product) Request.Get(this.url + "/product/" + id)
      .addHeader("Accept", "application/json")
      .execute().handleResponse(httpResponse -> {
        try {
          ObjectMapper mapper = new ObjectMapper();
          Product product = mapper.readValue(httpResponse.getEntity().getContent(), Product.class);

          return product;
        } catch (JsonMappingException e) {
          throw new IOException(e);
        }
      });
  }

  ...
}
```

This class, and specifically the `getProduct()` method, will be the target of our Pact test.

### Check

Before moving to the next step, check the following:

1. You have run the following command and it has succeeded `./gradlew`{{execute}}
