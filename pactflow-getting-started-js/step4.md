# Publish to Pactflow

Now that we have created our contract, we need to share the contract to our provider. This is where Pactflow comes in to the picture. This step is referred to as "publishing" the pact.

1. Go to Pactflow and copy your [read/write API Token](https://docs.pactflow.io/#configuring-your-api-token)
1. Export these two environment variables into the terminal, being careful to replace the placeholders with your own values:

    ```
    export PACT_BROKER_BASE_URL=https://YOUR_PACTFLOW_SUBDOMAIN.pactflow.io
    export PACT_BROKER_TOKEN=YOUR_API_TOKEN
    ```

1. `npm run publish`{{execute}}
1. Go to your Pactflow dashboard and check that a new contract has appeared

Your dashboard should look something like this:

![pactflow-dashboard-unverified](./assets/pactflow-dashboard-unverified.png)

Note the pact is currently "unverified" because the provider has never confirmed it can fulfill the contract.

When pacts and verification results are published, we set the "branch" property for the application version.

Read more about [branches](https://docs.pact.io/pact_broker/branches/) in Pact.

When an application version is deployed or released, we use the `record-deployment` or `record-release` commands provided by the Pact Broker CLI to indicate which environment an application is in at any given time.
## Don't have a Pactflow account?

If you don't have a Pactflow account, you can publish a [test broker](https://test.pactflow.io) that uses the [open source pact broker](https://github.com/pact-foundation/pact_broker/).

```
export PACT_BROKER_BASE_URL=https://test.pactflow.io
export PACT_BROKER_USERNAME=dXfltyFMgNOFZAxr8io9wJ37iUpY42M
export PACT_BROKER_PASSWORD=O5AIZWxelWbLvqMd8PkAVycBJh2Psyg1
```{{execute}}

The account is protected using basic auth. Use the username `dXfltyFMgNOFZAxr8io9wJ37iUpY42M`, and password `O5AIZWxelWbLvqMd8PkAVycBJh2Psyg1` to view the pacts.