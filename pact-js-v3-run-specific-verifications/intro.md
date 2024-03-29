# In the scenario, you will learn about pact-js v3, via one of our examples

## Some notes on our tutorial platform

> <strong>When using the visual editor</strong> it's not possible yet to click-exec code into the Editor tab.
> All commands will be automatically switched to copy when using the visual editor, so you should switch to a tab to run commands, or switch to the editor to view the code

If you want to view a file, search with the prefix `pact-js/examples/v3/run-specific-verifications` to find the files specific to this example, or look in the editors file-tree

> 1. Ensure the `editor` tab is open
> 2. Click on the folder name above, so it is in your clipboard
> 3. Click into the editor window and press `ctrl+p`(windows/unix) or `command+p`(mac) to search for a file
> 4. Press `ctrl+v`(windows/unix) or `command+v`(mac) to paste the project path and select a file from the list

## Overview

## run specific verifications example

Using some pre-created pact files we are demonstrating the possibility to rerun specific verifications by filtering using env. variables.

Main documentation:

<a href="https://docs.pact.io/implementation_guides/javascript/docs/troubleshooting#re-run-specific-verification-failures" target="_blank">Re-run specific verification failures
</a>

This folder contains 3 pact files, each file contains some interactions that should be run, and some that should be skipped.

Every test that should be skipped sends a `GET` requests to the `/fail` endpoint and expects `"result": "OK"`.

If those interactions are executed they will fail (because the endpoint `/fail` does not return the expected result) and with it the whole test-run.

That way these tests are also used as automated tests for pact-js itself and check if the filtering works correctly. To achieve that the env variables are set inside of `test/provider.spec.js` using `process.env.`.

To play around with the filtering, do the following and see what interactions are executed

- delete the `process.env. ...` lines in `test/provider.spec.js`
- set the env. variables outside the test run e.g. `PACT_DESCRIPTION="a request to be skipped" npm run test:provider`{{execute}}

## Running the tests

1. `npm install`{{execute}} (on the root project directory) - This has already been performed for you, when the tutorial started!
2. `npm run test:provider`{{execute}} - Run provider tests
3. delete the `process.env.PACT_DESCRIPTION` line in `test/provider.spec.js`
4. `PACT_DESCRIPTION="a request to be skipped" npm run test:provider`{{execute}} - This should fail
5. `PACT_DESCRIPTION="a request to be used" npm run test:provider`{{execute}} - This should pass