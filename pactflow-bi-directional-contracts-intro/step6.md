## The Consumer

Time to create our consumer code base.

In our project, we're going to need:

-  A model (the `Product` class) to represent the data returned from the Product API: ``example-bi-directional-consumer-mountebank/src/api.js`{{open}}
* A client (the `ProductApiClient`) which will be responsible for making the HTTP calls to the Product API and returning an internal representation of an Product: ``example-bi-directional-consumer-mountebank/src/product.js`{{open}}

Install the dependencies for the project: `npm i`{{execute}}

### Product Model

<pre class="file">
export class Product {
  constructor({id, name, type}) {
    if (!id || !name || !type) {
      throw Error("id, name and type are required properties")
    }
    this.id = id
    this.name = name
    this.type = type
  }
}
</pre>

###  Product API Client

Here is a simplified version of our API client code. This code is responsible for fetching products from the API, and returning a `Product`:

<pre class="file">
const axios = require("axios");
const { Product } = require("./product");

export class ProductAPIClient {
  constructor(url) {
    if (url === undefined || url === "") {
      url = process.env.BASE_URL;
    }
    if (url.endsWith("/")) {
      url = url.substr(0, url.length - 1);
    }
    this.url = url;
  }

  withPath(path) {
    if (!path.startsWith("/")) {
      path = "/" + path;
    }
    return `${this.url}${path}`;
  }

  async getAllProducts() {
    return axios
      .get(this.withPath("/products"))
      .then((r) => r.data.map((p) => new Product(p)));
  }

  async getProduct(id) {
    return axios
      .get(this.withPath("/product/" + id))
      .then((r) => new Product(r.data));
  }
}

</pre>

This class, and specifically the `getProduct()` and `getAllProducts` methods, will be the target of our contract tests.

### Check

Before moving to the next step, check the following:

1. There is a file called `package.json` in your editor
1. You have run `npm i`{{execute}} and the dependencies have been installed
1. There is a file called `product.js` in your editor
1. There is a file called `api.js` in your editor

