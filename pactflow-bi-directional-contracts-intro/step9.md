# Deploy the consumer

Now that we have tested our consumer and published our consumer contract, we can deploy the application to production.

Just like our provider counterpart, we're going to call `can-i-deploy` to check if it's safe before we do.

_REMEMBER: The `can-i-deploy` command is an important part of a CI/CD workflow, adding stage gates to prevent deploying incompatible applications to environments such as production_

This diagram shows an illustrative CI/CD pipeline as it relates to our progress to date:

![consumer pipeline run](./assets/consumer-pipeline.png)

Let's run the command:

`npx pact-broker can-i-deploy --pacticipant pactflow-example-consumer-mountebank --version $GIT_COMMIT --to-environment production`{{execute}}

This should pass, because the provider has already published its contract and deployed to production, and we believe the consumer is compatible with the provider OAS:

```
$ npx pact-broker can-i-deploy --pacticipant pactflow-example-consumer-dredd --version $GIT_COMMIT --to-environment production
Computer says yes \o/

There are no missing dependencies
```

We can now deploy our consumer to production. Once we have deployed, we let Pactflow know that the new version of the consumer has been promoted to that environment:

`npx pact-broker record-deployment --pacticipant pactflow-example-consumer-mountebank --version $GIT_COMMIT --environment production`{{execute}}

# Check

Your dashboard should look something like this, where both your consumer and consumer are marked as having been deployed to `production`:

TBC

![pactflow dashboard - completed](./assets/pactflow-dashboard-complete.png)

<!-- ## Deploy

So we've created our consumer, published the contract and now it's time to deploy to production!

Before we do, however, we can check if this is safe to do:

`npm run can-deploy:consumer`{{execute}}

You should see the following output:

```

> npx pact-broker can-i-deploy --pacticipant katacoda-consumer --version 1.0.0-someconsumersha --to prod

Computer says no ¯\_(ツ)\_/¯

| CONSUMER          | C.VERSION             | consumer          | P.VERSION | SUCCESS? |
| ----------------- | --------------------- | ----------------- | --------- | -------- |
| katacoda-consumer | 1.0.0-someconsumersha | katacoda-consumer | ???       | ???      |

There is no verified pact between version 1.0.0-someconsumersha of katacoda-consumer and the latest version of katacoda-consumer with tag prod (no such version exists)

```

Oh oh! We can't deploy yet, because our consumer has yet to be created, let alone confirm if it can satisfy our needs.

The `can-i-deploy` command is an important part of a CI/CD workflow, adding stage gates to prevent deploying incompatible applications to environments such as production.

This diagram shows an illustrative CI/CD pipeline as it relates to our progress to date:

![first consumer pipeline run](./assets/consumer-run-1.png)

## Check

There should be a contract published in your Pactflow account before moving on -->

```

```
