# Getting Started

## Deploying a Smart Contract

## Resources

  [MyEtherWallet](https://www.myetherwallet.com/)

  [VS Code](https://code.visualstudio.com/)

  [VS Code Solidity Extension](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)

  Get some GO — Ask for some free testnet GO in our Testnet [Telegram](https://t.me/gochain_testnet) or buy some on KuCoin to deploy  to mainnet

## Deploying

### Sample Solidity Code

* To get started, copy the code sample below and paste into VS Code in a new file called mytoken.sol

```text
pragma solidity ^0.4.20;

contract MyToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyToken(
        uint256 initialSupply
        ) public {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        return true;
    }
}
```

### Compile the code

1. Compile the code by clicking on 'compile' or pressing F5
2. This will create a few files in a bin/ directory, open MyToken.bin. This contains your contract bytecode, which you’ll use below.

## Deploy your Contract

### This is really easy using the GoChain Wallet:

1. Go to [https://wallet.gochain.io/](https://wallet.gochain.io/)
2. In the top right, choose TestNet
3. Click Open Wallet
4. Paste your private key for your testnet wallet that has the GO you got from our Telegram
5. Click Deploy Contract
6. Copy the contents of MyToken.bin into the Bytecode field
7. Click Send!

### Contract Address

* After a few seconds your contract will be deployed and you’ll get a contract address, copy the address and save it somewhere. 
* That address is what people will use to interact with your contract.

  **Example: 0xd0a6e6c54dbc68db5db3a091b171a77407ff7ccf**

## Using your new GoChain Contract

1. Send GO directly. 
2. Deploy a DApp
3. Using MyEthereWallet
4. Using GoChain Wallet

