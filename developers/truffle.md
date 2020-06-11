# Using Truffle Framework with GoChain

You can use [Truffle Framework](https://truffleframework.com/) like you normally do and simply update your `truffle-config.js` configuration file to point to a GoChain network.

Below is an example `truffle-config.js` config file that uses GoChain. To use this, first:

```sh
npm install truffle-privatekey-provider
# Set a private key to use that has some GO in its account, do not include '0x' in the address
export WEB3_PRIVATE_KEY=ABCD...
```

Then you can use this:

```js
const privateKey = process.env.WEB3_PRIVATE_KEY;
const PrivateKeyProvider = require("truffle-privatekey-provider");
const Web3 = require('web3');

module.exports = {
  networks: {
    development: {
      provider: () => new PrivateKeyProvider(privateKey, "http://localhost:8545"),
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    testnet: {
      provider: () => new PrivateKeyProvider(privateKey, "https://testnet-rpc.gochain.io"),
      network_id: "*", // Match any network id
      gas: 2e7,
      gasPrice: 4e9
    },
    mainnet: {
      provider: () => new PrivateKeyProvider(privateKey, "https://rpc.gochain.io"),
      network_id: "*", // Match any network id
      gas: 2e7,
      gasPrice: 4e9
    }
  }
};
```

Then just use Truffle as you always do, but deploy to GoChain!
