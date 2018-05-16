# For Authorized Signers

## Running a Node

### Prerequisites

* Docker > 18.0 ([lnk](https://docs.docker.com/install/))
* Docker-compose ([link](https://docs.docker.com/compose/install/))

### Initial Configuration

1. Put your password in `password.txt` in same folder with `docker-compose.yml`
2. Create an account for reward activities.

```sh
docker run --rm -v $PWD:/root gochain/gochain gochain --datadir /root/node --password /root/password.txt account new
```

3. Backup the `node/keystore` directory you just created! If you lose it, you will lose all of your rewards!
4. Copy `example.env` to `.env` file (make it default for `docker-compose`)
5. Update `example.env` (replace `ACCOUNT_YOU_GOT_ON_STEP_2` with `account_id` you got on step 2)
6. Update `app.json` (replace `YOUR_SECRET` with secret that you got from GoChain team and `YOUR_NODE_NAME` with name of your company)
7. Launch `docker-compose`

```sh
docker-compose up -d
```

8. Make sure that node works

```sh
docker logs -f node
```

9. Reach gochain team with `account_id` to add you into the list of signers
