If you've made it this far, you should now have a basic understanding of how Pact and Pactflow work together to make it safe to release software into production quickly and reliably.

## Next Steps?

Here are a few things to try to see what scenarios Pact can help you with:

1. Try changing the provider code in a backwards incompatible way, what happens?
   1. First remove the 'id' key in the `provider.js` file
   2. `npm run test:provider`{{execute}}
   3. `npm run can-deploy:provider`{{execute}} - This should fail!
1. Try changing the provider code in a way that won't break existing consumers, but in a traditional "backwards incompatible" way, what happens?
   1. First remove the 'version' key in the `provider.js` file
   2. `npm run test:provider`{{execute}}
   3. `npm run can-deploy:provider`{{execute}} - This should _not_ fail - no consumers need this field!
1. Try adding a new expectation on the provider by updating the expected product in `consumer.pact.spec.js`:
   1. `npm run test:consumer`{{execute}}
   2. `npm run publish`{{execute}}
   3. `npm run can-deploy:consumer`{{execute}} - You shouldn't be able to deploy as no verifications are published!
   4. `npm run test:provider`{{execute}} - this should fail as the provider is not compatible with the latest pact
   5. `npm run can-deploy:consumer`{{execute}} - this should fail as the provider cannot satisfy the new field requirement

## Further material

You can see a `contract_published` event when a Pact is published. In the workshop below, you will lean how to configure the providers verification via webhooks, when publishing a consumer pact. This will give you accurate and up-to-date information when the consumer calls can-i-deploy

You may be interested in one of our longer form [workshops](https://docs.pact.io/implementation_guides/workshops), or getting deeper into [CI/CD](https://docs.pactflow.io/docs/workshops/ci-cd/) with Pact.
