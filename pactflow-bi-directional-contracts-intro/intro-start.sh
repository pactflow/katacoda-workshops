#!/bin/bash
echo "setup node 16"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && source ~/.bashrc && nvm install 16
echo "Downloading projects"
echo "=> downloading consumer project"
git clone https://github.com/pactflow/example-bi-directional-consumer-mountebank

echo "=> downloading provider project"
git clone https://github.com/pactflow/example-bi-directional-provider-dredd

echo "Changing into directory of the consumer project: /root/example-bi-directional-provider-dredd"
cd /root/example-bi-directional-provider-dredd
npm i
echo "force install absolute version"
npx -y @pact-foundation/absolute-version
echo "setting global git config for demo steps"
git config --global user.email "katacoda@pactflow.io"
git config --global user.name "demo"
echo "setup apt after cloning"
apt --yes install jq && clear && echo "Welcome to the Pactflow Tutorial, all the dependencies are installed, and you should be good to go!"
