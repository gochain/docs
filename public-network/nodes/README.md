# Running a Node

This directory contains instructions for configuring and running GoChain with `docker-compose` on the `testnet`, `mainnet`, a private network, or a local development instance.

Instructions for running a *signing* node are [here](../signers/nodes).

## Prerequisites

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

## Initial Configuration

\**Note: If you are moving from the testnet to the mainnet, it is best to start fresh in a new folder.*

1. Copy `docker-compose.yml` into your folder from either the [`testnet`](testnet) or [`mainnet`](mainnet) directory.
2. (Optional) Create a file `.env` to override the default variables: (see [`example.env`](example.env) for more details)
```
GOCHAIN_TAG=2.1.16
GOCHAIN_CACHE=16000
```
3. [Configure Linux limits](https://github.com/gochain/gochain/discussions/443)
4. Launch `docker-compose`

```sh
docker-compose up -d
```

5. Make sure the node works.

```sh
docker logs -f node
```

## Common Commands

- Start: `docker-compose up -d`
- Stop: `docker-compose down`
- Follow Logs: `docker logs -f --tail 100 node`
- Restart Container: `docker-compose restart node`
- Restart All: `docker-compose down && docker-compose up -d`
- Console Attach: `docker exec -it node gochain --datadir /gochain/node attach`
- Console Execute: `docker exec -t node gochain --datadir /gochain/node attach --exec 'admin.nodeInfo.enode'`
- Update image: `docker-compose pull`

### Console Commands

- Enode: `admin.nodeInfo.enode`
- Balance: `eth.getBalance('0xabcd')`
- Coinbase Balance (rewards): `eth.getBalance(eth.coinbase)` 
- Send Transaction (transfer rewards): `eth.sendTransaction({from:eth.coinbase,to:'0xabcd',value:web3.toWei(1,"ether")})`

More info on the console is available here: https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console

## Troubleshooting

If you are unable to diagnose a problem, you can try these steps in escalating order:

1) Repair: `docker-compose up -d`
2) Restart node: `docker-compose restart node`
3) Restart all: `docker-compose down && docker-compose up -d`
4) Restart docker: `service docker restart && docker-compose up -d`
5) Reboot machine, `docker-compose up -d`
