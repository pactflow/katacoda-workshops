#!/bin/bash
echo "setup node 16"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && source ~/.bashrc && nvm install 16
echo "=> Downloading pact-js"
git clone https://github.com/pact-foundation/pact-js

echo "Changing into directory of the consumer project: /root/pact-js/pact-js/examples/v3/e2e"
cd /root/pact-js/examples/v3/e2e
npm i

clear && echo "Welcome to the Pact-JS V3 Tutorial, all the dependencies are installed, and you should be good to go!"
