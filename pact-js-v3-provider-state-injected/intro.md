# In the scenario, you will learn about pact-js v3, via one of our examples

## Some notes on our tutorial platform

> <strong>When using the visual editor</strong> it's not possible yet to click-exec code into the Editor tab.
> All commands will be automatically switched to copy when using the visual editor, so you should switch to a tab to run commands, or switch to the editor to view the code

If you want to view a file, search with the prefix `pact-js/examples/v3/provider-state-injected` to find the files specific to this example, or look in the editors file-tree

> 1. Ensure the `editor` tab is open
> 2. Click on the folder name above, so it is in your clipboard
> 3. Click into the editor window and press `ctrl+p`(windows/unix) or `command+p`(mac) to search for a file
> 4. Press `ctrl+v`(windows/unix) or `command+v`(mac) to paste the project path and select a file from the list

## Overview

## Provider state injected example

This example follows what is described in the blog post: 

<a href="https://pactflow.io/blog/injecting-values-from-provider-states/" target="_blank">Injecting values from Provider States</a>



## Running the tests

1. `npm install`{{execute}} (on the root project directory) - This has already been performed for you, when the tutorial started!
2. `npm run test`{{execute}} - Run consumer and provider tests
3. `npm run test:consumer`{{execute}} - Run consumer tests
4. `npm run test:provider`{{execute}} - Run provider tests
