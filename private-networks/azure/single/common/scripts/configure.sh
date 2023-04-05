#!/bin/bash
# Functions
wait_for_files () {
    echo "Waiting for the files with extension ${1}: $(date)" >> ${HOMEDIR}/output.log
    COUNTER=0
    while sleep 10
    do
        FILES=$(sudo -H -u $AZUREUSER bash -c "ls ${HOMEDIR}/shared/*.${1} | wc -l")
        echo "Nodes count ${NODES_COUNT} files ${FILES} counter ${COUNTER} " >> ${HOMEDIR}/output.log
        if [ "$FILES" -ge "$NODES_COUNT" ]; then
            break;
        fi
        if [ "$COUNTER" -ge 60 ]; then
            exit 1;
        fi
        COUNTER=$[$COUNTER +1]
    done
    
}

#############
# Parameters
#############
AZUREUSER=$1
ARTIFACTS_URL_PREFIX=$2
ARTIFACTS_URL_SASTOKEN=$3
NETWORK_ID=$4
NODES_COUNT=$5
INITIAL_BALANCE=$6
STORAGE_ACCOUNT_NAME=$7
STORAGE_CONTAINER_NAME=$8
STORAGE_ACCOUNT_KEY=$9


printf -v INITIAL_BALANCE_HEX "%x" "$INITIAL_BALANCE"

######################
# URL parsing (root)
######################
ARTIFACTS_URL_ROOT=${ARTIFACTS_URL_PREFIX%\/*}

###########
# Constants
###########
HOMEDIR="/home/$AZUREUSER";

#############
# Use the default user
#############
cd "/home/$AZUREUSER";
echo "$@" >> $HOMEDIR/all.params
echo "Start time: $(date)" >> ${HOMEDIR}/output.log
###########################
# Prepare fuse config
###########################

echo "accountName $STORAGE_ACCOUNT_NAME" > $HOMEDIR/fuse_connection.cfg
echo "accountKey $STORAGE_ACCOUNT_KEY" >> $HOMEDIR/fuse_connection.cfg
echo "containerName $STORAGE_CONTAINER_NAME" >> $HOMEDIR/fuse_connection.cfg


###########################
# Copy asset files to home
###########################
echo "Downloading everything: $(date)" >> ${HOMEDIR}/output.log
curl --retry 10  --retry-delay 6 -L ${ARTIFACTS_URL_ROOT}/scripts/docker-compose.yml${ARTIFACTS_URL_SASTOKEN} -o $HOMEDIR/docker-compose.yml || exit 1;
curl --retry 10  --retry-delay 6 -L ${ARTIFACTS_URL_ROOT}/scripts/genesis${ARTIFACTS_URL_SASTOKEN} -o $HOMEDIR/genesis || exit 1;
curl --retry 10  --retry-delay 6 -L ${ARTIFACTS_URL_ROOT}/scripts/config${ARTIFACTS_URL_SASTOKEN} -o $HOMEDIR/config || exit 1;

#########################################
# Install docker and compose on all nodes
#########################################
echo "Installing docker,blobfuse: $(date)" >> ${HOMEDIR}/output.log
curl --retry 10  --retry-delay 6 -L https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb -o $HOMEDIR/packages-microsoft-prod.deb || exit 1;
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl --retry 10  --retry-delay 6 -fsSL https://download.docker.com/linux/ubuntu/gpg -o $HOMEDIR/gpg || exit 1;
sudo apt-key add $HOMEDIR/gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce blobfuse
sudo systemctl enable docker
sleep 5
sudo curl --retry 10  --retry-delay 6 -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose || exit 1;
sudo chmod +x /usr/local/bin/docker-compose

###########################
# Mounting fuse
###########################
echo "Mounting fuse: $(date)" >> ${HOMEDIR}/output.log
chown $AZUREUSER:$AZUREUSER $HOMEDIR/fuse_connection.cfg
chmod 700 $HOMEDIR/fuse_connection.cfg
mkdir -p /mnt/blobfusetmp
chown $AZUREUSER:$AZUREUSER /mnt/blobfusetmp
mkdir $HOMEDIR/shared
chown $AZUREUSER:$AZUREUSER $HOMEDIR/shared
sudo -H -u $AZUREUSER bash -c "blobfuse ${HOMEDIR}/shared --tmp-path=/tmp/blobfusetmp  --config-file=${HOMEDIR}/fuse_connection.cfg"

#########################################
echo "Generating account: $(date)" >> ${HOMEDIR}/output.log
date +%s | sha256sum | base64 | head -c 32 > $HOMEDIR/password.txt
ACCOUNT_ID=$(sudo docker run -v $PWD:/root ghcr.io/gochain/gochain gochain --datadir /root/node --password /root/password.txt account new | awk -F '[{}]' '{print $2}')

echo "GOCHAIN_ACCT=0x$ACCOUNT_ID" > $HOMEDIR/.env
echo "GOCHAIN_NETWORK=$NETWORK_ID" >> $HOMEDIR/.env

###########################
# Exchange configs
###########################
echo "Writing accounts: $(date)" >> ${HOMEDIR}/output.log
sudo -H -u $AZUREUSER bash -c "echo '    \"0x${ACCOUNT_ID}\",' >> ${HOMEDIR}/shared/${ACCOUNT_ID}.account"
wait_for_files "account" #wait for files with extension *.account

############################
## Generate genesis
############################

echo "Generating genesis: $(date)" >> ${HOMEDIR}/output.log
ACCOUNTS=$(sudo -H -u $AZUREUSER bash -c "cat ${HOMEDIR}/shared/*.account")
ACCOUNTS=${ACCOUNTS%?}; # remove the last character
echo "ACCOUNTS ${ACCOUNTS}" >> ${HOMEDIR}/output.log
ACCOUNT=(${ACCOUNTS[@]});#get the first ACCOUNT from the list
ACCOUNT=${ACCOUNT%?}; # remove the last character
echo "ACCOUNT ${ACCOUNT}" >> ${HOMEDIR}/output.log
sed -i "s/#NETWORKID/$NETWORK_ID/g" $HOMEDIR/genesis || exit 1;
echo "$(awk -v  r="${ACCOUNTS}" "{gsub(/#ACCOUNTS/,r)}1" genesis)" > genesis #write only first account here
sed -i "s/#ACCOUNT/$ACCOUNT/g" $HOMEDIR/genesis || exit 1;
sed -i "s/#HEX/$INITIAL_BALANCE_HEX/g" $HOMEDIR/genesis || exit 1;

mv $HOMEDIR/genesis $HOMEDIR/genesis.json

# ###########################
# # Init nodes
# ###########################

sudo rm -rf $PWD/node/GoChain
docker run --rm -v $PWD:/gochain -w /gochain ghcr.io/gochain/gochain gochain --datadir /gochain/node init genesis.json

# ###########################
# # Generate config
# ###########################

echo "console.log(admin.nodeInfo.enode);" > $HOMEDIR/node/enode.js
ENODE_OUTPUT=$(docker run -v $PWD:/root ghcr.io/gochain/gochain gochain --datadir /root/node js /root/node/enode.js)
ENODE=${ENODE_OUTPUT:0:137}
IP_ACCOUNT=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
sudo -H -u $AZUREUSER bash -c "echo '  \"${ENODE}${IP_ACCOUNT}:30303\",' >> ${HOMEDIR}/shared/${ACCOUNT_ID}.enode"
echo "Enode:${ENODE}" >> ${HOMEDIR}/output.log

wait_for_files "enode" #wait for files with extension *.enode

echo "Generating config: $(date)" >> ${HOMEDIR}/output.log
ENODES=$(sudo -H -u $AZUREUSER bash -c "cat ${HOMEDIR}/shared/*.enode")
# ENODES=${ENODES%?}; # remove the last character
sed -i "s/#NETWORKID/$NETWORK_ID/g" $HOMEDIR/config || exit 1;
echo "$(awk -v  r="${ENODES}" "{gsub(/#NODES/,r)}1" config)" > config
mv $HOMEDIR/config $HOMEDIR/config.toml

# #########################################
# # Install docker image from private repo
# #########################################
docker-compose up -d