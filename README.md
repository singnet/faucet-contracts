# SingularityNET token faucet contracts

Smart contracts for [Faucet by SingularityNET](faucet.singularitynet.io/)

## Functional requirements
The possibility for users to receive text tokens
Admin functionality
* Configurable interval from request to token request
* Configurable size of the number of tokens to receive
* Withdrawal of tokens from a smart contract


Supported Tokens:
- Symbol `AGIX`
  - Decimals `8`
---------------
- Symbol `RJV`
  - Decimals `6`

## Techical requirements
1. For V1 need send AGIX or RJV tokens to contract address for distribution tokens

2. For V2 need grant minter role for faucet contract for mint tokens from contract

## Faucet token contract for each testnet
- ✔️ V1.Goerli [0x19570fbC4e05940960b0A44C5f771008Af7935A2](https://goerli.etherscan.io/address/0x19570fbC4e05940960b0A44C5f771008Af7935A2) (LTS ending in dec 2023)
- ❌ V2.Goerli (Not supported)
- ⏳ V1.Sepolia - Migrating phase
- ⏳ V2.Sepolia - Migrating phase   

## Development instructions
* Install [Node.js and npm](https://nodejs.org/)
* `npm install -g truffle` to get Truffle at globally
* `npm install` to get dependencies

### Deployment instructions
* `truffle compile` for compile contracts
* `truffle migrate --network <NETWORK>` for compile contracts