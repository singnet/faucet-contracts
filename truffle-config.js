const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require("fs");

require('dotenv').config({ path: '.env'});
const MNEMONIC = fs.readFileSync(".secret").toString().trim();

const { INFURA, ETHSKAN } = process.env;

module.exports = {
  networks: {
    sepolia: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://sepolia.infura.io/v3/${INFURA}`),
      network_id: 11155111,
      gas: 29000000
    },
    goerli: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://goerli.infura.io/v3/${INFURA}`),
      network_id: 5,
      gas: 2000000
    },
  },
  mocha: {
    enableTimeouts: false,
    reporter: 'eth-gas-reporter',
    reporterOptions : {
        currency: 'USD',
        onlyCalledMethods: 'true',
        showTimeSpent: 'true'
    }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: ETHSKAN
  },
  compilers: {
    solc: {
      version: "0.8.9",      // Fetch exact version from solc-bin (default: truffle's version)
    }
  },
};