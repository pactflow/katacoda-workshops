// (1) Import the pact library and matching methods
const { Pact } = require ('@pact-foundation/pact');
const { ProductApiClient } = require ('./api');
const { Product } = require ('./product');
const { Matchers } = require("@pact-foundation/pact")
const { like, regex } = Matchers
const chai = require("chai")
const expect = chai.expect

// (2) Configure our Pact library
const mockProvider = new Pact({
  consumer: 'katacoda-consumer',
  provider: 'katacoda-provider',
  cors: true // needed for katacoda environment
});

describe('Products API test', () => {
  // (3) Setup Pact lifecycle hooks
  before(() => mockProvider.setup());
  afterEach(() => mockProvider.verify());
  after(() => mockProvider.finalize());

  it('get product by ID', async () => {
    // (4) Arrange
    const expectedProduct = { id: 10, type: 'pizza', name: 'Margharita' }

    await mockProvider.addInteraction({
      state: 'a product with ID 10 exists',
      uponReceiving: 'a request to get a product',
      withRequest: {
        method: 'GET',
        path: '/products/10'
      },
      willRespondWith: {
        status: 200,
        headers: {
          'Content-Type': regex({generate: 'application/json; charset=utf-8', matcher: '^application\/json'}),
        },
        body: like(expectedProduct),
      },
    });

    // (5) Act
    const api = new ProductApiClient(mockProvider.mockService.baseUrl);
    const product = await api.getProduct(10);

    // (6) Assert that we got the expected response
    expect(product).to.deep.equal(new Product(10, 'Margharita', 'pizza'));
  });
});