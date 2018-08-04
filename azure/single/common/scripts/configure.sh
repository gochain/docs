#!/bin/bash

#############
# Parameters
#############
AZUREUSER=$1
ARTIFACTS_URL_PREFIX=$2
DNS_NAME=$3
NETWORK_ID=$4
INITIAL_BALANCE=$5
printf -v INITIAL_BALANCE_HEX "%x" "$INITIAL_BALANCE"
printf -v CURRENT_TS_HEX "%x" $(date +%s)
###########
# Constants
###########
HOMEDIR="/home/$AZUREUSER";
CONFIG_LOG_FILE_PATH="$HOMEDIR/config.log";

#############
# Use the default user
#############
cd "/home/$AZUREUSER";

###########################
# Cache the scripts locally
###########################
curl -L ${ARTIFACTS_URL_PREFIX}/scripts/docker-compose.yml -o $HOMEDIR/docker-compose.yml
curl -L ${ARTIFACTS_URL_PREFIX}/scripts/genesis.json -o $HOMEDIR/genesis.json

#########################################
# Install docker and compose on all nodes
#########################################
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl enable docker
sleep 5
sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#########################################
date +%s | sha256sum | base64 | head -c 32 > password.txt
ACCOUNT_ID=$(sudo docker run -v $PWD:/root gochain/gochain gochain --datadir /root/node --password /root/password.txt account new | awk -F '[{}]' '{print $2}')

echo "GOCHAIN_ACCT=0x$ACCOUNT_ID" > $HOMEDIR/.env
echo "GOCHAIN_NETWORK=$NETWORK_ID" >> $HOMEDIR/.env

sed -i "s/<network_id>/$NETWORK_ID/" $HOMEDIR/genesis.json || exit 1;
sed -i "s/<current_ts_hex>/$CURRENT_TS_HEX/" $HOMEDIR/genesis.json || exit 1;
sed -i "s/<signer_address>/$ACCOUNT_ID/" $HOMEDIR/genesis.json || exit 1;
sed -i "s/<voter_address>/$ACCOUNT_ID/" $HOMEDIR/genesis.json || exit 1;
sed -i "s/<address>/$ACCOUNT_ID/" $HOMEDIR/genesis.json || exit 1;
sed -i "s/<hex>/$INITIAL_BALANCE_HEX/" $HOMEDIR/genesis.json || exit 1;

sudo sudo rm -rf $PWD/node/GoChain
sudo docker run --rm -v $PWD:/gochain -w /gochain gochain/gochain gochain --datadir /gochain/node init genesis.json
#########################################
# Install docker image from private repo
#########################################
sudo docker-compose up -d