# Running an Authorized Signer Node

This directory contains instructions for configuring and running an authorized signer node on either the GoChain `testnet` or `mainnet`.

## Prerequisites

### Quick Start

We have a quick start script here that will do all of the prerequisites below in one shot:

```sh
wget https://raw.githubusercontent.com/gochain/docs/refs/heads/master/public-network/signers/nodes/setup.sh
chmod a+x setup.sh
./setup.sh
```

Then open a NEW terminal window to use the new settings. 

### Manual configuration

<details>
<summary>Open for manual instructions</summary>
  
Update a few Linux settings to ensure things run smoothly.

Update `vm.max_map_count`:

```sh
sysctl -w vm.max_map_count=262144
nano /etc/sysctl.conf
# Add the following line:
vm.max_map_count = 262144
```

Then increase the ulimit for the root user (assuming you are using root to run docker). Check current setting with `ulimit -n`, if it's a lot higher than 1024, you're good. If not, do this:

```sh
ulimit -n 100000
nano /etc/security/limits.conf
# Add the following line to it:
root             soft    nofile          100000
```

Install `docker` and `docker-compose`.

* Docker > 25.0 ([install](https://docs.docker.com/engine/install/))

Quick Docker install:

```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
</details>

Open a new terminal just to be sure all the settings kick in. 

## Initial Configuration

\**Note: If you are moving from the testnet to the mainnet, it is best to start fresh in a new folder.*

Create a `/gochain` directory on the root of your machine.

A complete configuration looks like:

```
|-config.toml
|-docker-compose.yml
|-.env
|-node/keystore
|-password.txt
```

1. Copy `config.toml` and `docker-compose.yml` into your folder from either the [`testnet`](testnet) or [`mainnet`](mainnet) directory.
2. Create a file `password.txt` with your password.
3. Create an account for reward activities. Note the logged address.

```sh
docker run --rm -v $PWD:/root ghcr.io/gochain/gochain gochain --datadir /root/node --password /root/password.txt account new
```

4. **Backup the `node/keystore` directory you just created! If you lose it, you will lose all of your rewards!**
5. Create a file `.env` to set the required variables: (see [`example.env`](example.env) for more details and optional variables)
```
GOCHAIN_ACCT=0x12345 # Use the address from step 3.
GOCHAIN_EXTRADATA="My Company Name" # Each signed block will have this permanently included.
NETSTATS_NAME="My Company Name" # Display for netstats web interface.
NETSTATS_SECRET=secret # Ask the GoChain team for this secret.
# GOCHAIN_CACHE=16000 # Change this depending on your server's available memory.
```
6. Launch `docker compose`

```sh
docker compose up -d
```

7. Make sure that node works. Note the `enode` address logged on startup. 
(The `enode` can also be retrieved by [attaching to the console](https://github.com/orgs/gochain/discussions/154) and executing `admin.nodeInfo.enode`)

```sh
docker logs -f --tail 50 node
```

8. Get [enode](https://github.com/orgs/gochain/discussions/160) to add to config.toml

## Common Commands

Common commands [here](../../nodes/README.md#common-commands).
