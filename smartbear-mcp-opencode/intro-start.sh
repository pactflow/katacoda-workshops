#!/bin/bash

echo "Installing system dependencies"
apt update && apt --yes install jq curl git && \
echo "Setting up Node.js 20" && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
nvm install 20 && \
nvm use 20 && \
echo "Node.js version:" && node --version && \
echo "npm version:" && npm --version && \
cd ~ && \
clear && echo "Welcome! Dependencies are installed, you are good to go."
