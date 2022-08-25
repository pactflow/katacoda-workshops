# In the scenario, you will learn about pact-js v3, via one of our examples

## Some notes on our tutorial platform

> <strong>When using the visual editor</strong> it's not possible yet to click-exec code into the Editor tab.
> All commands will be automatically switched to copy when using the visual editor, so you should switch to a tab to run commands, or switch to the editor to view the code

If you want to view a file, search with the prefix `pact-js/examples/v3/e2e` to find the files specific to this example, or look in the editors file-tree

> 1. Ensure the `editor` tab is open
> 2. Click on the folder name above, so it is in your clipboard
> 3. Click into the editor window and press `ctrl+p`(windows/unix) or `command+p`(mac) to search for a file
> 4. Press `ctrl+v`(windows/unix) or `command+v`(mac) to paste the project path and select a file from the list

## Overview

Using a simple animal dating API, we demonstrate the following Pact features:

- Consumer testing and pact file generation, including advanced features like:
  - [Flexible matching](https://docs.pact.io/getting_started/matching#flexible-matching)
  - [Provider states](https://docs.pact.io/getting_started/provider_states)
- Sharing Pacts by publishing to and retrieving from a [Pact Broker](https://github.com/pact-foundation/pact_broker)
- Provider side verification

This comprises a complete E2E example that can be used as a basis for projects.

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [The Example Project](#the-example-project) - [Provider (Profile API)](#provider-profile-api) - [Consumer (Matching API)](#consumer-matching-api)
- [Running the tests](#running-the-tests)
- [Running the API](#running-the-api) - [Animal Profile API](#animal-profile-api) - [GET /animals](#get-animals) - [GET /animals/:id](#get-animalsid) - [GET /animals/available](#get-animalsavailable) - [POST /animals](#post-animals) - [Matching service](#matching-service) - [GET /suggestions/:id](#get-suggestionsid)
- [Viewing contracts with the Pact Broker](#viewing-contracts-with-the-pact-broker)
<!-- /TOC -->

## The Example Project

[Matching API] -> [Profile API]+\(DB\)

### Provider (Profile API)

Provides Animal profile information, including interests, zoo location and other personal details.

### Consumer (Matching API)

Given an animal profile, recommends a suitable partner based on similar interests.

## Running the tests

1. `npm install`{{execute}} (on the root project directory) - This has already been performed for you, when the tutorial started!
2. `npm run test:consumer`{{execute}} - Run consumer tests
3. `npm run test:publish`{{execute}} - Publish contracts to the broker
4. `npm run test:provider`{{execute}} - Run provider tests

[![asciicast](https://asciinema.org/a/105793.png)](https://asciinema.org/a/105793)

## Running the API

If you want to experiment with the API to get an understanding:

1. `npm run api`{{execute}} - Runs the both provider and consumer API

or individually :

1. `npm run provider`{{execute}} - Runs the provider API (animal service)
1. `npm run consumer`{{execute}} - Runs the consumer API (matching service)

### Animal Profile API

The APIs are described below, including a bunch of cURL statements to invoke them.

Click on the `+` icon next to `Tab1` to open a new tab to run these!

#### GET /animals

```
curl -H "Authorization: Bearer 1234" -X GET "http://localhost:8081/animals" | jq .
```{{execute}}

#### GET /animals/:id

```

curl -H "Authorization: Bearer 1234" -X GET "http://localhost:8081/animals/1" | jq .

```{{execute}}

#### GET /animals/available

```

curl -H "Authorization: Bearer 1234" -X GET http://localhost:8081/animals/available | jq .

```{{execute}}

#### POST /animals

```

curl -H "Authorization: Bearer 1234" -X POST -H "Content-Type: application/json" -d '{
"first_name": "aoeu",
"last_name": "aoeu",
"age": 21,
"gender": "M",
"location": {
"description": "Melbourne Zoo",
"country": "Australia",
"post_code": 3000
},
"eligibility": {
"available": true,
"previously_married": false
},
"interests": [
"walks in the garden/meadow",
"munching on a paddock bomb",
"parkour"
]
}' "http://localhost:8081/animals" | jq .

```{{execute}}

### Matching service

#### GET /suggestions/:id

```

curl -H "Authorization: Bearer 1234" -X GET http://localhost:8080/suggestions/1 | jq .

```{{execute}}

## Viewing contracts with the Pact Broker

A test [Pact Broker](https://github.com/bethesque/pact_broker) is running at https://test.pactflow.io:

- Username: `dXfltyFMgNOFZAxr8io9wJ37iUpY42M`
- Password: `O5AIZWxelWbLvqMd8PkAVycBJh2Psyg1`

Or use the API:

```

curl -v -u 'dXfltyFMgNOFZAxr8io9wJ37iUpY42M:O5AIZWxelWbLvqMd8PkAVycBJh2Psyg1' https://test.pactflow.io | jq .

```{{execute}}
