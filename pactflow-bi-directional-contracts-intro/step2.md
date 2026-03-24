## The Provider

### Design the API

As we are following a specification or [design first approach](https://swagger.io/blog/api-design/design-first-or-code-first-api-development/) to API development, we start by creating an [OpenAPI](https://oai.github.io/Documentation/start-here.html) description document, that describes how our API should work.

Authoring an OAS document is beyond the scope of this tutorial, but you can find plenty of resources on the internet (such as at [swagger.io](https://swagger.io)).

```
openapi: 3.1.1
info:
  title: Product API
  description: PactFlow Product API demo
  version: 1.0.0
servers:
- url: /
paths:
  /products:
    get:
      summary: List all products
      description: Returns all products
      operationId: getAllProducts
      security:
        - bearerAuth: []
      responses:
        "200":
          description: successful operation
          content:
            application/json;charset=utf-8:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Product'
              examples:
                application/json:
                  value:
                    - id: "10"
                      type: "beverage"
                      price: 10.99
                      name: "cola"
                      version: "1.0.0"
        "401":
          description: Unauthorized - missing or invalid token
          content: {}
    post:
      summary: Create a product
      description: Creates a new product
      operationId: createProduct
      security:
        - bearerAuth: []
      requestBody:
        description: Create a new Product
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Product'
            examples:
              application/json:
                value:
                  id: "666"
                  type: "beverage"
                  price: 10.99
                  name: "cola"
                  version: "1.0.0"
        required: true
      responses:
        "201":
          description: successful operation
        "401":
          description: Unauthorized - missing or invalid token
          content: {}
  /product/{id}:
    get:
      summary: Find product by ID
      description: Returns a single product
      operationId: getProductByID
      security:
        - bearerAuth: []
      parameters:
      - name: id
        in: path
        description: ID of product to get
        required: true
        style: simple
        explode: false
        schema:
          type: string
        example: "10"
      responses:
        "200":
          description: successful operation
          content:
            application/json;charset=utf-8:
              schema:
                $ref: '#/components/schemas/Product'
              examples:
                application/json:
                  value:
                    id: "666"
                    type: "beverage"
                    price: 10.99
                    name: "cola"
                    version: "1.0.0"
        "400":
          description: Invalid ID supplied
          content: {}
        "401":
          description: Unauthorized - missing or invalid token
          content: {}
        "404":
          description: Product not found
          content: {}
components:
  securitySchemes:
    # Bearer token format is "Bearer <ISO8601 timestamp>"
    bearerAuth:
      type: http
      scheme: bearer
  schemas:
    Product:
      type: object
      required:
        - id
        - name
        - price
      properties:
        id:
          type: string
        type:
          type: string
        name:
          type: string
        version:
          type: string
        price:
          type: number
```

As you can see, we have 3 main endpoints:

1. `POST /products` - create a new product
1. `GET /products` - gets all products
1. `GET /product/:id` - gets a single product

Having designed our API, we can now set about building it.

### Implement the Product API

Here is the Product API using the [Express JS](https://expressjs.com) framework. Once again, writing an API is beyond the scope of this tutorial.

_NOTE: you can see the full project here: <https://github.com/pactflow/example-bi-directional-provider-drift>_

We define our product, the available routes, the datastore (an simple in-memory database) and the server.

1. Ensure the `editor` tab is open
2. Click on a filename(s) below to copy it
3. Click into the editor window and press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

`example-bi-directional-provider-drift/src/product/product.js`{{copy}}

```
class Product {
    constructor(id, type, name, version, price) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.version = version;
        this.price = price;
        if (!id || !type || !name || price === undefined || price === null) {
            throw new Error("Invalid product");
        }
    }
}

module.exports = Product;
```

`example-bi-directional-provider-drift/src/product/product.routes.js`{{copy}}

```
const router = require('express').Router();
const controller = require('./product.controller');

router.get("/product/:id", controller.getById);
router.get("/products", controller.getAll);
router.post("/products", controller.create);

module.exports = router;
```

`src/product/repositories/InMemoryRepository.js`{{copy}}

```
const Product = require('../product');

const defaultProducts = [
    ["9", new Product("9", "CREDIT_CARD", "Gem Visa", "v1", 59.95)],
    ["10", new Product("10", "CREDIT_CARD", "28 Degrees", "v1", 28.0)],
    ["11", new Product("11", "PERSONAL_LOAN", "MyFlexiPay", "v2", 199.0)],
];

class InMemoryRepository {

    constructor() {
        this.products = new Map(defaultProducts);
    }

    async fetchAll() {
        return [...this.products.values()]
    }

    async getById(id) {
        return this.products.get(id);
    }

    async add(product) {
        return this.products.set(product.id, product);
    }
    
    setupProducts(products) {
        this.products = new Map();
        const productList = Array.isArray(products) ? products : [];

        for (const product of productList) {
            const normalized = product instanceof Product
                ? product
                : new Product(product.id, product.type, product.name, product.version, product.price);
            this.products.set(`${normalized.id}`, normalized)
        }
    }

    resetProducts() {
        this.products = new Map(defaultProducts);
    }
}

module.exports = InMemoryRepository;
```

`example-bi-directional-provider-drift/src/product/product.controller.js`{{copy}}

1. Click the filename above to copy.
2. Ensure the `editor` tab is open
3. press `ctrl+p` or `command+p` to search for a file
4. Press `ctrl+v` or `command+v` to paste the filename and select the file from the list

```
const Product = require("./product");
const RepositoryFactory = require("./repositories/RepositoryFactory");

let repository = null;

// Initialize repository asynchronously
const initializeRepository = async () => {
    if (!repository) {
        repository = await RepositoryFactory.create();
    }
    return repository;
};

exports.admin = async (req, res) => {
    console.log("admin");
    console.log(req.body);

    res.status(200).send();
};

exports.getAll = async (req, res) => {
    console.log("getAll");
    const repo = await initializeRepository();
    res.send(await repo.fetchAll())
};

exports.getById = async (req, res) => {
    console.log("getById", req.params.id);
    if (!req.params.id) {
        res.status(400).send({message: "Product ID is required"});
        return;
    }
    const repo = await initializeRepository();
    const product = await repo.getById(req.params.id);
    product ? res.send(product) : res.status(404).send({message: "Product not found"})
};

exports.create = async (req, res) => {
    console.log("create", req.body);
    try {
        const product = new Product(req.body.id, req.body.type, req.body.name, req.body.version, req.body.price);
        const repo = await initializeRepository();
        await repo.add(product);
        res.status(201).send()
    } catch {
        res.status(400).send({message: "Invalid product"})
    }
};

exports.setup = async (req, res) => {
    console.log('setup', req.body)
    const repo = await initializeRepository();
    const products = Array.isArray(req.body.products) ? req.body.products : [];
    await repo.setupProducts(products)
    res.status(200).send()
};

exports.teardown = async (req, res) => {
    console.log('teardown')
    const repo = await initializeRepository();
    await repo.resetProducts()
    res.status(200).send()
};

exports.initializeRepository = initializeRepository;
exports.getRepository = () => repository;
```

`example-bi-directional-provider-drift/server.js`{{copy}}

```
const app = require('express')();
const cors = require('cors');
const bodyParser = require('body-parser');
const routes = require('./src/product/product.routes');
const authMiddleware = require('./src/middleware/auth.middleware');
const controller = require('./src/product/product.controller');

const port = 8080;

const init = async () => {
    // Initialize repository before setting up routes
    await controller.initializeRepository();
    
    app.use(cors());
    app.use(authMiddleware);
    app.use(bodyParser.json());
    app.use(routes);
    return app.listen(port, () => console.log(`Provider API listening on port ${port}...`));
};

init();
```

### Check

Before moving to the next step, cd into the `example-bi-directional-provider-drift` directory and run the provider to see if it starts.

The tutorial environment should have installed 2 projects and their dependencies. Once the terminal process completes you can run:

1. `cd /root/example-bi-directional-provider-drift`{{execute}}
1. `npm i`{{execute}}
1. `npm start`{{execute}}

Open up a separate terminal and run the following command:

1. `cd /root/example-bi-directional-provider-drift`{{execute}}
1. `curl -H "Authorization: Bearer $(date)" localhost:8080/products | jq .`{{execute}}

You should see the following output:

```
[
  {
    "id": "09",
    "type": "CREDIT_CARD",
    "name": "Gem Visa",
    "version": "v1",
    "price": 99.99
  },
  {
    "id": "10",
    "type": "CREDIT_CARD",
    "name": "28 Degrees",
    "version": "v1",
    "price": 49.49
  },
  {
    "id": "11",
    "type": "PERSONAL_LOAN",
    "name": "MyFlexiPay",
    "version": "v2",
    "price": 16.5
  }
]
```

Switch back to your first terminal and terminate (`ctrl-c`) the process to make sure your provider is no longer running.
