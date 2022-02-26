In the scenario, you will learn the basics of bi-directional contract testing with Pactflow.

The course is written in NodeJS, however, extensive experience with the language will not be required for the workshop.

## Workshop Prerequisites

You must have:

- a Pactflow account (https://pactflow.io)
- obtained a [read/write API Token](https://docs.pactflow.io/docs/getting-started/#configuring-your-api-token) from your Pactflow account

## Goals

You will:

1. Create and document an API using [OpenAPI Specification](https://www.openapis.org/)
1. Write tests for the API using the Dredd API testing tool
1. Publish the _provider contract_ (an OpenAPI document) to Pactflow
1. Prevent deploying breaking changes to an environment, such as production
1. Write tests for an API client using mocks, and convert those mocks into a _consumer contract_
1. Publish the consumer contract to Pactflow
1. Learn how deployments work with Pactflow

We will use specific testing tools in this workshop, but as you will learn, you can use many different tools to achieve the same outcome.
