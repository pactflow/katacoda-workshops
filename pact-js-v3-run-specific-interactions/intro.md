# In the scenario, you will learn about pact-js v3, via one of our examples

## Some notes on our tutorial platform

> <strong>When using the visual editor</strong> it's not possible yet to click-exec code into the Editor tab, but it's
> already planned for a future update. Till then, all exec will be automatically switched to copy when using the visual editor, so you should switch to a tab to run commands, which you can click on directly to run in a tab, and switch to the editor to view the source code

If you want to view a file, search with the prefix `pact-js/examples/v3/e2e` to find the files specific to this example, or look in the editors file-tree

> 1. Ensure the `editor` tab is open
> 2. Search for the filename, ensuring you
> 3. Click into the editor window and press `ctrl+p`(windows/unix) or `command+p`(mac) to search for a file
> 4. Press `ctrl+v`(windows/unix) or `command+v`(mac) to paste the project path and select a file from the list

## Overview

## run specific verifications example

Using some pre-created pact files we are demonstrating the possibility to rerun specific verifications by filtering using env. variables.

Main documentation: https://github.com/pact-foundation/pact-js/#re-run-specific-verification-failures

This folder contains 3 pact files, each file contains some interactions that should be run, and some that should be skipped. Every test that should be skipped sends a `GET` requests to the `/fail` endpoint and expects `"result": "OK"`. If those interactions are executed they will fail (because the endpoint `/fail` does not return the expected result) and with it the whole test-run. That way these tests are also used as automated tests for pact-js itself and check if the filtering works correctly. To achieve that the env variables are set inside of `test/provider.spec.js` using `process.env.`.

To play around with the filtering delete the `process.env. ...` lines in `test/provider.spec.js`, set the env. variables outside the test run e.g. `PACT_DESCRIPTON="a request to be skipped" npm run test:provider` and see what interactions are executed

## Running the tests

1. `npm install`{{execute}} (on the root project directory) - This has already been performed for you, when the tutorial started!
2. `npm run test:provider`{{execute}} (from e2e directory) - Run provider tests
