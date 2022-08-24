#!/bin/bash
echo "setup node 16"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && source ~/.bashrc && nvm install 16
echo "=> Downloading pact-js"
git clone https://github.com/pact-foundation/pact-js

root_dir=/root/
example=pact-js/examples/v3/e2e
project=${root}${example}

echo "Changing into directory of the consumer project: $project"
cd $project
npm i

export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
clear && echo "Welcome to the Pact-JS V3 Tutorial, all the dependencies are installed, and you should be good to go! \\n \
You are in $project directory \\n \
You can switch to the editor tab, to look in the code \\n \
press ctrl+p or cmd +p in the editor window, to search for a specific file in the $example directory"
