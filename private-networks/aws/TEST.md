# How to test

1. Launch a gochain single node from a marketplace or using the template
2. Check if the node is running   
```curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://IP_ADDRESS_OF_THE_NODE:8545```

You should receive something like that:

```{"jsonrpc":"2.0","id":67,"result":"GoChain/v2.1.36/linux-amd64/go1.10.3"}```
  
3. Ssh into the instance and get an initial allocation address

```cat genesis.json | grep alloc -C 1 ```

You should get few lines, copy one with 40 symbols (and add 0x in the beginning of this line)

```0x21aca1c055e459808506a37b1a0079723314c18f ```

4. Check that you have something on your initial account via API

```curl http://IP_ADDRESS_OF_THE_NODE:8545  -H 'content-type: application/json;' --data-binary '[{"id":"94455d269e0ee68abf391d9923d26b13","jsonrpc":"2.0","method":"eth_getBalance", "params":["0x21aca1c055e459808506a37b1a0079723314c18f","pending"]}]'```

You should see initial balance that you set in wizard:

```[{"jsonrpc":"2.0","id":"94455d269e0ee68abf391d9923d26b13","result":"0xd46b9bd62f3ba7e0"}]```


5. Get the password of the genesis account (run this on the instance you connected)

``` cat password.txt```

6. Launch the interactive gochain console

```sudo docker run --rm -it -v $PWD:/gochain -w /gochain ghcr.io/gochain/gochain gochain --datadir /gochain/node attach```

7. Check the balance of the genesis account

```eth.getBalance('0x21aca1c055e459808506a37b1a0079723314c18f')```

8. Go to [GochainWallet](https://wallet.gochain.io/create-account) and create a new account (a public and a private key)
9. Check the balance of the new account in the interactive gochain console 

```eth.getBalance('0x50C7b8FD0150553E30305059d07f40ac0776a6cc')```

10. Unlock the genesis account in the interactive gochain console (the address from the step 3 and the password from the step 5) 

```personal.unlockAccount("0x21aca1c055e459808506a37b1a0079723314c18f","MGY1ZjA3YWYxZDkwZTRhNDNiOTUzNzE1");```

11. Transfer some GO from the genesis account to the new one that you created on the step 8
 
 ```eth.sendTransaction({from:"0x21aca1c055e459808506a37b1a0079723314c18f",to:'0x50C7b8FD0150553E30305059d07f40ac0776a6cc',value:1000000000000000000})```
 
12. Check the balance of the new account using curl via API
```curl http://40.118.229.215:8545  -H 'content-type: application/json;' --data-binary '[{"id":"94455d269e0ee68abf391d9923d26b13","jsonrpc":"2.0","method":"eth_getBalance", "params":["0x50C7b8FD0150553E30305059d07f40ac0776a6cc","pending"]}]' ```

And you should get something like that:

```[{"jsonrpc":"2.0","id":"94455d269e0ee68abf391d9923d26b13","result":"0xde0b6b3a7640000"}]```
