## The Provider

### Scope of a Provider pact test

On the Provider side, Pact needs to replay all of the interactions \(usually HTTP requests\) against your service. There are a number of choices that can be made here, but usually these are the choices:

* Invoke just the controller layer \(in an MVC app, or the "Adapter" in our diagram\) and stub out layers beneath
* Choosing a real vs mocked out database
* Choosing to hit mock HTTP servers or mocks for external services

Generally speaking, we test the entire service and mock out external services such as downstream APIs \(which would need their own set of Pact tests\) and databases. This gives you some of the benefits of an integration test without the high costs of maintenance.

This is how you might visualise the coverage of a provider Pact test:

![Provider side Pact test scope](./assets/provider-test-coverage.png)

### Create the Product API

Here is the Product API using the [Express JS](https://expressjs.com) framework.

<pre class="file" data-filename="provider.js" data-target="replace">
const express = require("express")
const cors = require("cors")

const server = express()
server.use(cors())
server.use((req, res, next) => {
  res.header("Content-Type", "application/json; charset=utf-8")
  next()
})

server.get("/products/:id", (req, res) => {
  res.json({id: 1, name: "aussie", type: "hamburger", version: "1.0.0"})
})

module.exports = {
  server
}
</pre>

Create the `product.js` file.

### Check

Before moving to the next step, check the following:

1. There is a file called `provider.js` in your editor