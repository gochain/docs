# Usign web3.py

[Web3.py](https://github.com/ethereum/web3.py) is a python library for web3 blockchains. 

To use it with GoChain, set the following environment variable:

```sh
export WEB3_PROVIDER_URI=https://rpc.gochain.io
```

Then in your code, load web3.py like this:

```sh
import json 
from web3.auto import w3
print(w3.eth.getBlock('latest'))
```
