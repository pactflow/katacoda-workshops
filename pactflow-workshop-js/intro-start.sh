#!/bin/bash
echo "=> downloading workshop"
git clone https://github.com/pact-foundation/pact-workshop-js

echo "Changing into directory of the workshop: /root/pact-workshop-js"
cd /root/pact-workshop-js

echo "setup node 16"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && source ~/.bashrc && nvm install 16
apt --yes install jq && clear && echo "Welcome to the PactFlow Tutorial, all the dependencies are installed, and you should be good to go!"
