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
4. `docker-compose restart node` - restart the `node` container.
