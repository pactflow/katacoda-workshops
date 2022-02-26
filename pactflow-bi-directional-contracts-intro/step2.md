## The Provider

### Design the API

### Implement the Product API

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
