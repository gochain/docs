curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
mkdir -p /gochain/node/keystore
cd /gochain
wget https://raw.githubusercontent.com/gochain/docs/master/public-network/signers/nodes/mainnet/config.toml
wget https://raw.githubusercontent.com/gochain/docs/master/public-network/signers/nodes/mainnet/docker-compose.yml
echo "Setup your .env file, your password.txt and create or copy your keystore file"
