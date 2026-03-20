#!/bin/bash
echo "setup node 24"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash && source ~/.bashrc && nvm install 24 && nvm use 24
echo "Downloading projects"
echo "=> downloading consumer project"
git clone https://github.com/pactflow/example-bi-directional-consumer-mountebank --branch feat/advanced-drift

echo "=> downloading provider project"
git clone https://github.com/mefellows/example-provider --branch feat/advanced-drift

echo "Changing into directory of the provider project: /root/example-provider"
cd /root/example-provider
npm i
echo "force install absolute version"
npx -y @pact-foundation/absolute-version
echo "setting global git config for demo steps"
git config --global user.email "katacoda@pactflow.io"
git config --global user.name "demo"
echo "setup apt after cloning"
apt --yes install jq && clear && echo "Welcome to the PactFlow Tutorial, all the dependencies are installed, and you should be good to go!"
