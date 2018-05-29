# Burn Process

Follow the steps below to swap your GOCX tokens on Ethereum to GO tokens on the GoChain MainNet.

* Go to: https://www.myetherwallet.com/#contracts
* Enter: `10xdeCeac4Cbb3E30A40091e7d73D0a16ddF88f1C6d1` for Contract Address
* Paste below into “ABI / JSON Interface”:
  * `[{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]`
* In Read/Write Contract section:
  * Choose "burn" function
  * Enter value of your tokens in WEI (IMPORTANT that it's in wei)
    * Add 18 0’s to the end of your amount to convert to wei: 000000000000000000
    * Eg: if you have 20,000 tokens to burn, use: 20000000000000000000000
* Click "Write" and follow the rest of the instructions on MyEtherWallet.
* Send your burn transaction URL from etherscan back to us. You can continue the conversation here: https://gochain.io/tokengen
  * This is what a burn transaction looks like: https://etherscan.io/tx/0x855ed9da9d8a981e351c9616f9329d96c54e97a42de8efd85b409b5003352528
