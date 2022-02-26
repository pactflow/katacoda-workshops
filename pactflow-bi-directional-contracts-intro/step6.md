## The Consumer

Time to create our consumer code base.

In our project, we're going to need:

* A model (the `Product` class) to represent the data returned from the Product API
* A client (the `ProductApiClient`) which will be responsible for making the HTTP calls to the Product API and returning an internal representation of an Product.

Note that to create a Pact test, you do need to write the code that executes the HTTP requests to your service (in your client class), but you don't need to write the full stack of consumer code (eg. the UI).

### Scope of a Consumer Pact Test

Ideally, the Pact tests should be a unit test for your API client class, and they should just focus on ensuring that the request creation and response handling are correct. If you use pact for your UI tests, you'll end up with an explosion of redundant interactions that will make the verification process tedious. Remember that pact is for testing the contract used for communication, and not for testing particular UI behaviour or business logic.

Usually, your application will be broken down into a number of sub-components, depending on what type of application your consumer is \(e.g. a Web application or another API\). This is how you might visualise the coverage of a consumer Pact test:

![Scope of a consumer Pact test](./assets/consumer-test-coverage.png)

Here, a _Collaborator_ is a component whose job is to communicate with another system. In our case, this is the `API` class communicating with the external `Product API` system. This is what we want our consumer test to inspect.

### Create a new Project

Create the following `package.json` to initialise new npm project by choosing `"copy to editor"`. This should open up a new file in the editor to the right, and populate it with the contents below.
We'll use this approach moving forward as we progress through the workshop.

We need two dev dependencies to run our pact tests:

1. Mocha to use as our unit testing framework (we are also using Chai.js for assertions)
2. Pact for our API assertions

We have some other dependencies for our Provider and some additional scripts which can be ignored for now.

<pre class="file" data-filename="package.json" data-target="replace">
{
  "name": "pactflow-getting-started-js",
  "version": "0.1.0",
  "dependencies": {
    "axios": "^0.19.1",
    "cors": "^2.8.5",
    "express": "^4.17.1"
  },
  "scripts": {
    "test:consumer": "mocha --exit --timeout 30000 consumer.pact.spec.js",
    "test:provider": "mocha --exit --timeout 30000 provider.pact.spec.js",
    "publish": "npx pact-broker publish ./pacts --consumer-app-version 1.0.0-someconsumersha --tag master",
    "can-deploy:consumer": "npx pact-broker can-i-deploy --pacticipant katacoda-consumer --version 1.0.0-someconsumersha --to prod",
    "can-deploy:provider": "npx pact-broker can-i-deploy --pacticipant katacoda-provider --version 1.0.0-someprovidersha --to prod",
    "deploy:consumer": "npx pact-broker create-version-tag --pacticipant katacoda-consumer --version 1.0.0-someconsumersha --tag prod",
    "deploy:provider": "npx pact-broker create-version-tag --pacticipant katacoda-provider --version 1.0.0-someprovidersha --tag prod"
  },
  "devDependencies": {
    "@pact-foundation/pact": "^9.9.12",
    "chai": "^4.2.0",
    "mocha": "^8.1.3"
  }
}
</pre>

Install the dependencies for the project: `npm i`{{execute}}

(click on the highlighted command above to run `npm i` automatically in the terminal window to the right. Again, look out for these as we progress through the workshop)

### Create our Product Model

Now that we have our basic project, let's create our `Product` domain model:

<pre class="file" data-filename="product.js" data-target="replace">
class Product {
  constructor(id, name, type) {
    this.id = id
    this.name = name
    this.type = type
  }
}
module.exports = {
  Product
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