## Step 10 - Request Filters on the Provider

Because our pact file has static data in it, our bearer token is now out of date, so when Pact verification passes it to the Provider we get a `401`. There are multiple ways to resolve this - mocking or stubbing out the authentication component is a common one. In our use case, we are going to use a process referred to as _Request Filtering_, using a `RequestFilter`.

_NOTE_: This is an advanced concept and should be used carefully, as it has the potential to invalidate a contract by bypassing its constraints. See https://github.com/DiUS/pact-jvm/blob/master/provider/junit/README.md#modifying-the-requests-before-they-are-sent for more details on this.

The approach we are going to take to inject the header is as follows:

1. If we receive any Authorization header, we override the incoming request with a valid (in time) Authorization header, and continue with whatever call was being made
1. If we don't receive an Authorization header, we do nothing

_NOTE_: We are not considering the `403` scenario in this example.

In `provider/product/product.pact.test.js`:

```javascript
// add this to the Verifier opts
requestFilter: (req, res, next) => {
  if (!req.headers["authorization"]) {
    next();
    return;
  }
  req.headers["authorization"] = `Bearer ${ new Date().toISOString() }`;
  next();
},
```

We can now run the Provider tests

Click - `npm run test:pact --prefix provider`{{execute}}

```console
❯ npm run test:pact --prefix provider


```

_Move on to [step 11](https://github.com/pact-foundation/pact-workshop-js/tree/step11#step-11---using-a-pact-broker)_
