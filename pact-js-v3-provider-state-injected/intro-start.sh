#!/bin/bash
echo "setup node 16"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && source ~/.bashrc && nvm install 16
echo "=> Downloading pact-js"
git clone https://github.com/pact-foundation/pact-js

$project=pact-js/examples/v3/provider-state-injected

echo "Changing into directory of the project: $project"
cd $project
# chai is a temp plaster until update_examples_deps branch is merged on pact-js
npm i && npm install --save-dev chai

export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
apt --yes install jq && clear && cat <<-END
"Welcome to the Pact-JS V3 Tutorial, all the dependencies are installed, and you should be good to go!
You are in $project directory
You can switch to the editor tab, to look in the code
press ctrl+p or cmd +p in the editor window, to search for a specific file in the $project directory"
END
