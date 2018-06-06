# Running a Private Network

This directory contains instructions for configuring and running a private GoChain network with `docker-compose`.

It is recommended to first read the [node](../) and [signer](../../signers) instructions for the GoChain `mainnet` and `testnet`.
A private GoChain network will operate in the same way, but with a custom genesis block

## Prerequisites

`docker` and `docker-compose` - installation instructions [here](../README.md). 

## Initial Configuration

You may start with a single voter/signer node and [add more later](adding-more-nodes), or setup multiple at once and include them from the genesis.

1. Copy `config.toml`, `docker-compose.yml`, and `genesis.json` into a directory.
2. Create a file `password.txt` with your password.
3. Create an account. Note the logged address:

```sh
docker run --rm -v $PWD:/root gochain/gochain gochain --datadir /root/node --password /root/password.txt account new
```

4. Create any initial allocation accounts. You may want to create separate accounts to hold some initial allocations.
The same command from (3) can be used, but the `keystore`s should be kept separate.    

5. **Backup the `node/keystore` directories you just created!**

6. Choose a unique network/chain id. The GoChain `mainnet` and `testnet` use `60` and `31337`. You should try to choose
a number not already in use by any other GoChain or Ethereum networks.

7. Each node needs it's own `.env` with the account address and network/chain id:

```
GOCHAIN_ACCT=0x123456
GOCHAIN_NETWORK=100
```
You may optionally override `GOCHAIN_CACHE` or `GOCHAIN_TAG` as well.

### Creating the Genesis Block

The genesis block specifies the intial voters, signers, and allocations, along with other customizable information.
The uniqueness of your genesis block distinguishes your network from other networks which may have coincidentally chosen the same network/chain id.
[genesis.json](genesis.json) contains an incomplete, bare-bones genesis file example, based on the one used on the GoChain `testnet`.
You can copy this file and fill in the `<variable>`s with your custom values. Optionally, you may include additional allocations and signers or 
voters (Only one required, can vote more in later); the gas limit can be set now (or later); and the first 32 bytes of `extra data` can be anything you want 
(UTF-8 string recommended, e.g. `GoChain`: `"extraData": "0x476f436861696e00000000000000000000000000000000000000000000000000"`). 

## Running the Node

First you must initialize from the `genesis.json` file:
```sh
docker run --rm -it -v $PWD:/gochain -w /gochain gochain/gochain gochain --datadir /gochain/node init genesis.json
```
Then you can run normally with `docker-compose`:
```sh
docker-compose up -d
```

Check the node logs and note the `enode` address logged on startup: 
```sh
docker logs -f node
```
(The `enode` can also be retrieved by attaching to the console and executing `admin.nodeInfo.enode`)

**Backup the `node/GoChain/nodekey` file!** - This determines your enode public key.

## Adding more Nodes

Additional nodes can be run in the same manner. Nodes can be connected to one another by attaching to the console and executing
`admin.addPeer(<enode>)`. For example: 
```sh
docker run --rm -it -v $PWD:/gochain -w /gochain gochain/gochain gochain --datadir /gochain/node attach
> admin.addPeer('enode://dd72567042f67053e04ccaed6a0bb335a3694a19da44547bce9040e76c2adfcdf6c729181c3700d7de927bf1444d25c91359e3536eeb5a945b00d2efb5739c9a@159.65.169.181:30303')
```
If nodes intend to sign and/or vote, and they were not included in the genesis file, then they can be voted in via the console, using the `clique` api:
```sh
docker run --rm -it -v $PWD:/gochain -w /gochain gochain/gochain gochain --datadir /gochain/node attach
> clique
{
  proposals: {},
  discard: function(),
  getProposals: function(callback),
  getSigners: function(),
  getSignersAtHash: function(),
  getSnapshot: function(),
  getSnapshotAtHash: function(),
  getVoters: function(),
  propose: function(),
  proposeVoter: function()
}
> clique.getSigners()
["0x7aeceb5d345a01f8014a4320ab1f3d467c0c086a"]
> clique.getVoters()
["0x7aeceb5d345a01f8014a4320ab1f3d467c0c086a"]
> clique.propose("0xf9d5c49b0012eb7ea376a83c6f488fe305f2eaca", true)
...
> clique.getSigners()
["0x7aeceb5d345a01f8014a4320ab1f3d467c0c086a","0xf9d5c49b0012eb7ea376a83c6f488fe305f2eaca"]
> clique.proposeVoter("0xf9d5c49b0012eb7ea376a83c6f488fe305f2eaca", true)
...
> clique.getVoters()
["0x7aeceb5d345a01f8014a4320ab1f3d467c0c086a","0xf9d5c49b0012eb7ea376a83c6f488fe305f2eaca"]
> exit
```

### Static & Trusted Peers

Peer connections can made automatic and be prioritized over random connections by including `enode`s in your `config.toml` file.
The included `config.toml` file contains empty lists. Here is an example with `enode`s populated:

```toml
[Node.P2P]
StaticNodes = [
  "enode://02c2d10444a9aea86ed17674bb1d5b9d1c7bc94f89b74e245b6d17ed4a8eb5238b799df1371430be5fa0cdde48370501f52984f63c1be3cbae7521ea4bd09da4@138.68.1.11:30303",
  "enode://18eaf192a11c3ba56048a40cfc66a520fde4295d5d16b8fadfbd6c03a42ffe26e05f79a2630b2f0a6997ffe0c9d0ef5606e8e31de4d8f75125e8d6c858d53e56@138.68.48.206:30303",
  "enode://364f1c8b7ed18544c7582a7ac0cfd58e0a6b6836358fb1bbeae94559617579a0202e472808906bd5b710d2ce7efe0f24cd5524a8663526a8b3b83a5f22f8a77d@138.197.196.226:30303",
]
TrustedNodes = [
  "enode://02c2d10444a9aea86ed17674bb1d5b9d1c7bc94f89b74e245b6d17ed4a8eb5238b799df1371430be5fa0cdde48370501f52984f63c1be3cbae7521ea4bd09da4@138.68.1.11:30303",
  "enode://18eaf192a11c3ba56048a40cfc66a520fde4295d5d16b8fadfbd6c03a42ffe26e05f79a2630b2f0a6997ffe0c9d0ef5606e8e31de4d8f75125e8d6c858d53e56@138.68.48.206:30303",
  "enode://364f1c8b7ed18544c7582a7ac0cfd58e0a6b6836358fb1bbeae94559617579a0202e472808906bd5b710d2ce7efe0f24cd5524a8663526a8b3b83a5f22f8a77d@138.197.196.226:30303",
]
```

## Common Commands

Common commands [here](../README.md#common-commands).

## RPC Proxy

TODO How to run [rpc-proxy](https://github.com/gochain-io/rpc-proxy)

## Netstats

TODO How to run [netstats](https://github.com/gochain-io/netstats)

## Explorer

TODO How to run [explorer](https://github.com/gochain-io/explorer)

## Chainload

TODO How to run [chainload](https://github.com/gochain-io/chainload)
