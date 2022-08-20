# Pactflow In-Browser Workshops

We've created a few short, in-browser tutorials using the Killercoda platform to get you up and running quickly depending on your level.

The courses are written in Node and Java, however, extensive experience with the languages will not be required for the workshop.

_NOTE: To complete the workshop, you will need to authenticate to Killercoda (the online learning platform) with GitHub, Google, Twitter or LinkedIn._

![Node Tutorial](https://docs.pactflow.io/assets/images/katacoda-screenshot-07be4d6a6faa46c0406d36c987b2f4c5.png)

## Prerequisites

To complete these tutorials, you must have:

- a Pactflow account (register for a free account at https://pactflow.io/try-for-free)
- a [read/write API Token](https://docs.pactflow.io/docs/getting-started/#configuring-your-api-token) from your Pactflow account
- a basic understanding of APIs, unit testing and how to operate a linux terminal

## Getting Started with Pactflow

_Level: Beginner_

In this tutorial, we guide you through getting started with Pact and Pactflow.

You will create your first contract, publish it to Pactflow and verify it on your provider.

### Goals

Ultimately, our goal is to get you up and integrated with Pactflow as quickly as possible!

You will:

1. Learn the basic concepts of Pact.
1. Get hands-on experience with the key aspects of writing, publishing and verifying pacts.
1. See how Pactflow fits into the picture so that you can get up and running quickly.

### Tutorial

| Language | Link                                                                   |
| -------- | ---------------------------------------------------------------------- |
| Node JS  | https://killercoda.com/pactflow/scenario/pactflow-getting-started-js   |
| Java     | https://killercoda.com/pactflow/scenario/pactflow-getting-started-java |

## Gating deployments with Pactflow

_Level: Intermediate_

In the scenario, we extend the workshop from above, learning how to gate deployments using the `can-i-deploy` tool in the process.

### Goals

Learn how to prevent releasing incompatible changes to production, by using integrating `can-i-deploy` into your CI/CD process.

You will:

1. Build on a basic contract testing example
1. Learn how Pactflow fits into the picture
1. Understand important Pact CLI tools
1. Learn how deployments work with Pactflow

### Tutorial

You can complete the course at https://killercoda.com/pactflow/scenario/pactflow-can-i-deploy-js.

## Bi-Directional Contract Testing

_Level: Intermediate_

Learn how to implement a Bi-Directional Contract Testing workflow from end-to-end, including integration with your CI/CD system.

### Goals

You will learn how:

1. To use OpenAPI as part of a contract testing strategy
1. API testing tools such as Dredd or Postman can be used with Pactflow
1. To publish contracts (such as a pact file or an OpenAPI document) to Pactflow
1. To prevent deploying breaking changes to an environment, such as production
1. To use existing mocking tools (such as Mountebank or Wiremock) to create a consumer contract

### Agenda

You will:

1. Create and document an API using [OpenAPI Specification](https://www.openapis.org/)
1. Write tests for the API using the Dredd API testing tool
1. Publish the _provider contract_ (an OpenAPI document) to Pactflow
1. Deploy the provider to production
1. Write the API consumer
1. Write tests for an API client using Mountebank to mock the API, and convert those mocks into a _consumer contract_
1. Publish the consumer contract to Pactflow
1. Deploy the consumer to production
1. Learn about Pactflow's breaking change detection system

### Tools used

- Node - for the applications being tested
- [Mountebank](https://mbtest.org) - for API mocking
- [Dredd](https://dredd.org/en/latest/index.html) - for API Testing
- [Pact CLI tools](https://docs.pact.io/implementation_guides/cli)

### Tutorial

You can complete the course at https://killercoda.com/pactflow/scenario/pactflow-bi-directional-contracts-intro.
