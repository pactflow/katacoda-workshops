## Installation

PactFlow AI, comes as a command-line application called `pactflow-ai` which we will install to our machine.

Installation documentation is provided [here](https://docs.pactflow.io/docs/ai#installation).

We can run the following command to download `pactflow-ai` via it's installation script.

👉🏼 `curl https://download.pactflow.io/ai/get.sh  | PACTFLOW_AI_YES=1 sh`{{exec}}

We will set an environment variable `PACTFLOW_AI_YES` to disable the confirmation prompt.

The installer will automatically download the `pactflow-ai` binary, and add its location to your `PATH`.

You may need to source your profile, in order for the `PATH` changes to be reflected.

👉🏼 `source ~/.profile`{{exec}}

Take a look at the help for any options, by passing the `--help` flag.

👉🏼 `pactflow-ai --help`{{exec}}

Check the version number of the `pactflow-ai` tool.

👉🏼 `pactflow-ai version`{{exec}}

You can update the tool at any time, by running the install script again.

## Authentication

You'll need to authenticate the `pactflow-ai` tool, against your PactFlow account. See the [Authentication documentation](https://docs.pactflow.io/docs/ai#authentication) for more detail.

Log into your PactFlow account, and visit the Settings > Tokens page. Select `Copy Token Value` on the Read only token, and select `as Environment Variables`.

You can now paste the environment variables into the terminal on the right, and press Enter.

### Check

Before moving to the next step, check the following:

1. There is a binary accessible on the command line called `pactflow-ai`{{exec}}.
2. You can run the binary `pactflow-ai`{{exec}}
3. You've set your PactFlow authentication credentials. 
   1. environment variables `PACT_BROKER_BASE_URL` & `PACT_BROKER_TOKEN` in your shell.
