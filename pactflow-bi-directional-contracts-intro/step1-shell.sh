echo "Downloading projects"
echo "=> downloading consumer project"
git clone https://github.com/pactflow/example-consumer

echo "=> downloading provider project"
git clone https://github.com/pactflow/example-provider-dredd

echo "Changing into directory of the consumer project: /root/example-provider-dredd"
cd /root/example-provider-dredd
npm i