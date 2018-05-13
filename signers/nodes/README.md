# For Authorized Signers

## Running a Node

### Prerequisites

* Docker > 18.0

### Initial Configuration

Create an account for reward activities.

```sh
docker run --rm -it -v $PWD:/gochain -w /gochain gochain/gochain gochain --datadir /gochain/node account new
```

1. Remember the password you use!
2. Backup the `node/keystore` directory you just created! If you lose it, you will lose all of your rewards!

Copy the `example.env` file here to a `.env` file and fill it in with your information.

TODO

* user needs to update secret in app.json
* Fill in example.env file
