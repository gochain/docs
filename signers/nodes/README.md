# For Authorized Signers

## Running a Node

### Prerequisites

Install `docker` and `docker-compose`.

* Docker > 18.0 ([install](https://docs.docker.com/install/))
* Docker-compose ([install](https://docs.docker.com/compose/install/))

#### Simple Install Instructions

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

### Initial Configuration

1. Put your password in `password.txt` in same folder with `docker-compose.yml`
2. Create an account for reward activities.

```sh
docker run --rm -v $PWD:/root gochain/gochain gochain --datadir /root/node --password /root/password.txt account new
```

3. Backup the `node/keystore` directory you just created! If you lose it, you will lose all of your rewards!
4. Copy `example.env` to `.env` file (make it default for `docker-compose`)
5. Update `example.env` (replace `ADDRESS_YOU_GOT_ON_STEP_2` with the address from step 2)
6. Update `app.json` (replace `YOUR_SECRET` with secret that you got from GoChain team and `YOUR_NODE_NAME` with name of your company)
7. Launch `docker-compose`

```sh
docker-compose up -d
```

8. Make sure that node works

```sh
docker logs -f node
```

9. Contact the GoChain team with your account address to be added to the list of signers
