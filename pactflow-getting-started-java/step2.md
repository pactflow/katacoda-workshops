## The Consumer

Time to create our consumer code base.

In our project, we're going to need:

* A model (the `Product` class) to represent the data returned from the Product API
* A client (the `ProductClient`) which will be responsible for making the HTTP calls to the Product API and returning an internal representation of an Product.

Note that to create a Pact test, you do need to write the code that executes the HTTP requests to your service (in your client class), but you don't need to write the full stack of consumer code (eg. the UI).

### Scope of a Consumer Pact Test

Ideally, the Pact tests should be a unit test for your API client class, and they should just focus on ensuring that the request creation and response handling are correct. If you use pact for your UI tests, you'll end up with an explosion of redundant interactions that will make the verification process tedious. Remember that pact is for testing the contract used for communication, and not for testing particular UI behaviour or business logic.

Usually, your application will be broken down into a number of sub-components, depending on what type of application your consumer is \(e.g. a Web application or another API\). This is how you might visualise the coverage of a consumer Pact test:

![Scope of a consumer Pact test](./assets/consumer-test-coverage.png)

Here, a _Collaborator_ is a component whose job is to communicate with another system. In our case, this is the `API` class communicating with the external `Product API` system. This is what we want our consumer test to inspect.

### Create a new Project

We are going to be using Gradle as our build system, however you are free to use whatever build tool that you need (we support several other tools such as Maven and SBT). Open up the file `pactflow-example-consumer-java-junit/build.gradle`{{open}} to look at the dependencies needed for our project.

<pre class="file">
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
</pre>

Install dependencies for the project by running `./gradlew test`{{execute}}

(click on the highlighted command above to run `./gradlew test` automatically in the terminal window to the right. Again, look out for these as we progress through the workshop)

### Create our Product Model

Now that we have our basic project, let's create our `Product` domain model:

`pactflow-example-consumer-java-junit/src/main/java/com/example/products/Product.java{{open}}`
<pre class="file">
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
</pre>

### Create our Product API Client

Lastly, here is our API client code. This code is responsible for fetching products from the API, returning a `Product`:

<pre class="file" data-filename="api.js" data-target="replace">
const axios = require('axios');
const { Product } = require('./product');

class ProductApiClient {
  constructor(url) {
    this.url = url
  }

  async getProduct(id) {
    return axios.get(`${this.url}/products/${id}`).then(r => new Product(r.data.id, r.data.name, r.data.type));
  }
}
module.exports = {
  ProductApiClient
}
</pre>

This class, and specifically the `getProduct()` method, will be the target of our Pact test.

### Check

Before moving to the next step, check the following:

1. There is a file called `package.json` in your editor
1. You have run `npm i`{{execute}} and the dependencies have been installed
1. There is a file called `product.js` in your editor
1. There is a file called `api.js` in your editor