# SingularityNET Token Faucet Contracts

Smart contracts for [Faucet by SingularityNET](https://faucet.singularitynet.io/).

## Table of Contents
1. [Introduction](#introduction)
2. [Functional Requirements](#functional-requirements)
3. [Supported Tokens](#supported-tokens)
4. [Technical Requirements](#technical-requirements)
5. [Contracts for Testnets](#contracts-for-testnets)
6. [Contract Functions](#contract-functions)
7. [Development Instructions](#development-instructions)
8. [Deployment Instructions](#deployment-instructions)
9. [Configuration Files](#configuration-files)

---

## Introduction
This repository contains smart contracts designed for distributing testnet tokens (AGIX and RJV) to developers and testers via a configurable faucet. The faucet supports two operational modes: direct token distribution and minting.

---

## Functional Requirements
- Allow users to request test tokens.
- Provide admin functionalities:
  - Configure the interval between requests.
  - Configure the number of tokens per request.
  - Withdraw tokens from the contract.

---

## Supported Tokens
| Token | Symbol | Decimals | Address                                                                                                     |
|-------|--------|----------|-------------------------------------------------------------------------------------------------------------|
| AGIX  | `AGIX` | 8        | [0xf703b9aB8931B6590CFc95183be4fEf278732016](https://sepolia.etherscan.io/address/0xf703b9aB8931B6590CFc95183be4fEf278732016) |
| RJV   | `RJV`  | 6        | [0x0d5585ba627146bd27081099c75260da7086f682](https://sepolia.etherscan.io/token/0x0d5585ba627146bd27081099c75260da7086f682) |

---

## Technical Requirements
1. **Version 1:** Deposit AGIX or RJV tokens to the contract address for distribution.
2. **Version 2:** Grant the minter role to the faucet contract for minting tokens directly.

---

## Contracts for Testnets
| Version | Network  | Address                                                                                                       | Status                        |
|---------|----------|-------------------------------------------------------------------------------------------------------------|-------------------------------|
| V1      | Sepolia  | [0xB6E2421746BF4c5d941755c6272F9f2661282F78](https://sepolia.etherscan.io/address/0xB6E2421746BF4c5d941755c6272F9f2661282F78) | Active                        |
| V2      | Sepolia  | -                                                                                                           | Not in use (not supported)    |

---

## Contract Functions
### Read Functions
- **agixToken**: Returns the address of the AGIX token.
- **agixWithdrawalAmount**: Returns the amount of AGIX tokens available per request.
- **getBalance**: Displays the current token balances (AGIX and RJV) in the contract.
- **lockTime**: Shows the interval between token requests.
- **owner**: Returns the address of the contract owner.
- **rejuveToken**: Returns the address of the RJV token.
- **rejuveWithdrawalAmount**: Returns the amount of RJV tokens available per request.

### Write Functions
- **renounceOwnership**: Revokes ownership of the contract (irreversible).
- **requestTokens**: Allows users to request AGIX or RJV tokens.
- **setLockTime**: Sets the lock interval (in seconds) between token requests.
- **setWithdrawalAmount**: Configures the withdrawal amount for AGIX or RJV tokens.
- **transferOwnership**: Transfers ownership of the contract to another address.
- **withdraw**: Allows the contract owner to withdraw tokens from the contract.

---

## Development Instructions
1. Install [Node.js and npm](https://nodejs.org/).
2. Run `npm install -g truffle` to install Truffle globally.
3. Run `npm install` to install dependencies.

---

## Deployment Instructions
1. Run `truffle compile` to compile contracts.
2. Run `truffle migrate --network <network>` to deploy contracts.

---

## Configuration Files
### **.secret**
The `.secret` file is required for deploying the contracts and contains your wallet's **mnemonic phrase**. 

#### Creating the `.secret` file:
1. In the root of the project directory, create a new file named `.secret`.
2. Add your mnemonic phrase to the file (12 or 24 words), for example:
   ```
   candy maple cake sugar pudding cream honey rich smooth crumble sweet treat
   ```
3. **Do not share this file or upload it to version control (e.g., GitHub).** Make sure `.secret` is listed in `.gitignore`.
