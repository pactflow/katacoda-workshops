#!/bin/bash

echo "Installing apt dependencies"
apt --yes install jq && \
echo "setup node 20" && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && source ~/.bashrc && nvm install 20 && \
cd ~ && \
clear && echo "Welcome. The repo is downloaded, dependencies are installed, you are good to go."