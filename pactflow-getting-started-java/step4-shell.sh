echo "Installing Pact CLI Tools"
echo "=> downloading Pact CLI Tools"
curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/v1.88.26/pact-1.88.26-linux-x86_64.tar.gz
echo "=> extracting Pact CLI Tools"
tar xzf pact-1.88.26-linux-x86_64.tar.gz

echo "=> adding Pact CLI Tools to path"
export PATH="${PATH}:/root/example-consumer-java-junit/pact/bin/"

echo "=> testing Pact CLI Tools"
pact-broker --help publish

export COMMIT=`git rev-parse --short HEAD`
export BRANCH=`git rev-parse --abbrev-ref HEAD`