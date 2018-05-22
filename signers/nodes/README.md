# Running an Authorized Signer Node

## Prerequisites

Install `docker` and `docker-compose`.

* Docker > 18.0 ([install](https://docs.docker.com/install/))
* Docker-compose ([install](https://docs.docker.com/compose/install/))

<details>
  <summary>Simple Install Instructions</summary>

Docker:

```sh
sudo rm /var/lib/apt/lists/*
sudo apt-get update
curl -fsSL https://get.docker.com/ | sudo sh
docker info
```

Docker Compose:

```sh
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
```
</details>

## Initial Configuration

A complete configuration looks like:
```
|-config.toml
|-docker-compose.yml
|-.env
|-node/keystore
|-password.txt
```

1. Copy `config.toml` and `docker-compose.yml` into your folder.
2. Create a file `password.txt` with your password.
3. Create an account for reward activities. Note the logged address.

```sh
docker run --rm -v $PWD:/root gochain/gochain gochain --datadir /root/node --password /root/password.txt account new
```

4. **Backup the `node/keystore` directory you just created! If you lose it, you will lose all of your rewards!**
5. Create a file `.env` to set the required variables: (see [`example.env`](example.env) for more details and optional variables)
```
GOCHAIN_ACCT=0x12345 # Use the address from step 2.
NETSTATS_NAME="My Company Name"
NETSTATS_SECRET=secret # Ask the GoChain team for this secret.
```
6. Launch `docker-compose`

```sh
docker-compose up -d
```

7. Make sure that node works

```sh
docker logs -f node
```

10. Contact the GoChain team with your account address to be added to the list of signers

## Common Commands

1. `docker-compose up -d` - start or repair all containers.
1. `docker logs -f --tail 100 node` - follow the `node` container's logs.
2. `docker-compose down` - stop and remove all containers.
3. `docker-compose down && docker-compose up -d` - full cycle restart.
4. `docker-compose restart netintel` - restart the `netintel` container.

## Common Problems

### `netintel` fails to start

If you get an error starting `netintel` that looks like this:
```
Restarting netintel ... error

ERROR: for netintel  Cannot restart container d1eaa396240a0687fc4d7e301a90e512a90222d87a8c3a9e8a63d2c6767a069e: No such container: 39314384abb83d137f50479b3fd8613e76e7f48d1a6ea57fb32f438d0738a6b4
```
Usually the `node` container has crashed (or failed to start at all), and `docker logs node` will provide more insight about the real problem.

### Netstats shows node gray and inactive, but node is live

This generally just requires restarting the `netintel` container with `docker-compose restart netintel` to refresh the connection to the `node` container. If that does not work, it may require a full cycle restart, `docker-compose down && docker-compose up -d`.
