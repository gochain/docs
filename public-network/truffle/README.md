# Using Truffle Framework with GoChain

You can use [Truffle Framework](https://truffleframework.com/) like you normally do and simply update the configuration file to point to a GoChain network.

Here is an example `truffle.js` config file that uses GoChain:

```js
const privateKey = process.env.WEB3_PRIVATE_KEY;
const PrivateKeyProvider = require("truffle-privatekey-provider");
const Web3 = require('web3');

module.exports = {
  networks: {
    development: {
      provider: () => new PrivateKeyProvider(privateKey, "https://localhost:8545"),
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

To use the above file, you'll have to do the following first:

```sh
npm install truffle-privatekey-provider
# Set a private key to use that has some GO in its account
export WEB3_PRIVATE_KEY=0xABCD...
```

Then you can simply use Truffle as you always do, but deploy to GoChain!

