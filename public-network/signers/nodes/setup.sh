# OS Setup
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count = 262144" >> /etc/sysctl.conf
ulimit -n 100000
echo "root             soft    nofile          100000" >> /etc/security/limits.conf


#Docker
apt -y install curl
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# GoChain setup
mkdir -p /gochain/node/keystore
cd /gochain
wget https://raw.githubusercontent.com/gochain/docs/refs/heads/master/public-network/signers/nodes/mainnet/config.toml
wget https://raw.githubusercontent.com/gochain/docs/refs/heads/master/public-network/signers/nodes/mainnet/docker-compose.yml
wget -O .env https://raw.githubusercontent.com/gochain/docs/refs/heads/master/public-network/signers/nodes/example.env
echo "PASSWORD" >> ./password.txt

echo "Now update .env, password.txt and put your key in /gochain/node/keystore"
