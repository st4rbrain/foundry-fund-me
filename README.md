# Foundry Fund Me
This repository contains a FundMe smart contract with some additional tests and scripts to interact with the contract. This repository uses Foundry Framework as the development environment for building, testing, and deployment tasks.
### What is FundMe?
FundMe is a decentralized protocol allowing the contract owner to raise funds for any project. Users can contribute at least 5 USD based on network pair pricing, while only the owner can withdraw funds.
<br><br>

## Getting Started
### Requirements
  - **[git](https://git-scm.com/downloads)**
      - Download and install git from this link
      - Verify installation by running `git --version` in the terminal to see an output like `git version x.y.z`
  - **[foundry](https://book.getfoundry.sh/)**
      - Run the following command in the terminal:
          `curl -L https://foundry.paradigm.xyz | bash`
      - Open a new terminal and run `foundryup`
      - Verify installation by running `forge --version` in the terminal to see an output like `forge 0.2.0`
### Setup
  - Run these commands in the terminal: <br><br>
      ```bash
      git clone https://github.com/Cyfrin/foundry-fund-me-personal
      cd foundry-fund-me-personal
      forge build
      ```
      Setup completed!<br>
      **terminal refers to bash terminal in Linux or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)*
<br><br>
## Usage
### Testing
  1. Run all the test functions on the local [Anvil](https://book.getfoundry.sh/anvil/) chain
          
     ```bash
     forge test
     ```
  2. Run a particular test function<br>
     ```bash
     forge test --match-test testFunctionName
     ```
  3. Forked testing to test on a simulated testnet or mainnet<br>
     ```bash
     forge test --fork-url $SEPOLIA_RPC_URL
     ```
<br>

**To check the percentage of contract functions covered in tests**
```bash
forge coverage
```
<br> 

### Deployment
  1. **Deploy to Anvil Local Chain**
      - Temporary Anvil deployment (can't do any interactions with the contract deployed)
  
          ```bash
          forge script scripts/DeployFundMe.s.sol
          ```
      - Deploy to local Anvil chain
          - Open a second terminal and fire Anvil by running the command: &nbsp;&nbsp; `anvil`
          - Copy any of the ten private keys shown in the terminal
          - Run this command in the first terminal:
  
            ```bash
            forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key <COPIED_PRIVATE_KEY> --broadcast
            ```
            <br>
  2. **Deploy to Testnets or Mainnets**
     
      - Setup Environment Variables
         
          - Create a `.env` file in the working directory similar to `.env.example` in this repo
          - Set your own `SEPOLIA_RPC_URL` and `PRIVATE_KEY`<br><br>
      - &#x1F4A1; **`PRIVATE_KEY`** : &nbsp;&nbsp;Private Key of any account of your Web3 wallet (like Metamask)
      > NOTE: For development purposes, please use an account that doesn't have any real funds associated with it
      
      - &#x1F4A1; **`SEPOLIA_RPC_URL`**: &nbsp;&nbsp; API of the Sepolia testnet node you're working with. Get this for free from [Alchemy](https://alchemy.com/?a=673c802981)<br><br>
      - You can also add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/)
      - Get some testnet ETH from [Chainlink faucet](https://faucets.chain.link/)
      - Deploy by running the command:
    
        ```bash
        forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
        ```
  <br>

### Contract Interaction
  After deploying the contract to the testnet or to the local net, you can either directly interact with the contract or by running the scripts. 
  - Fund the FundMe contract
    - Direct interaction using terminal:
      
      ```bash
      cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --rpc-url $SEPOLIA_RPC_URL --private-key <PRIVATE_KEY>
      ```
    - By running the script in the terminal:
      ```bash
      forge script script/Interactions.s.sol:FundFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY  --broadcast
      ```
  - Withdraw from the FundMe contract
    - Direct interaction using terminal:
      
      ```bash
      cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --rpc-url $SEPOLIA_RPC_URL --private-key <PRIVATE_KEY>
      ```
    - By running the script in the terminal:
      ```bash
      forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $SEPOLIA_RPC_URL  --private-key $PRIVATE_KEY  --broadcast
      ```

# Thank You!
If you find this useful, feel free to contribute to this project by adding more functionality or finding any bugs 🤝

## You can also donate! 💸
**Metamsk Account Address**: 0x2726c81f38f445aEBA4D54cc74CBca4f51597D17
