#!/bin/bash

# Check if OpenCode config file exists
if [ -f "$HOME/.config/opencode/opencode.jsonc" ]; then
  echo "OpenCode config file exists"
else
  echo "ERROR: OpenCode config file not found"
  exit 1
fi

# Check if environment variables are set
if [ ! -z "$PACT_BROKER_BASE_URL" ]; then
  echo "PACT_BROKER_BASE_URL is set"
else
  echo "WARNING: PACT_BROKER_BASE_URL environment variable is not set"
fi

if [ ! -z "$PACT_BROKER_TOKEN" ]; then
  echo "PACT_BROKER_TOKEN is set"
else
  echo "WARNING: PACT_BROKER_TOKEN environment variable is not set"
fi

exit 0
