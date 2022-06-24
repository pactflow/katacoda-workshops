echo "Installing Pact CLI Tools"
echo "=> downloading Pact CLI Tools"
os='linux-x86_64'
tag=$(basename $(curl -fs -o/dev/null -w %{redirect_url} https://github.com/pact-foundation/pact-ruby-standalone/releases/latest))
filename="pact-${tag#v}-${os}.tar.gz"
curl -LO https://github.com/pact-foundation/pact-ruby-standalone/releases/download/${tag}/${filename}

echo "=> extracting Pact CLI Tools"
tar xzf ${filename}
rm ${filename}

echo "=> adding Pact CLI Tools to path"
export PATH="${PATH}:/root/example-consumer-java-junit/pact/bin/"

echo "=> testing Pact CLI Tools"
pact-broker --help publish

export COMMIT=$(git rev-parse --short HEAD)
export BRANCH=$(git rev-parse --abbrev-ref HEAD)
