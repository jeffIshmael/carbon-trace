require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.20",
    settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        viaIR: true // Enable the IR optimizer
      },
    networks: {
        // alfajores: {
        //     url: "https://alfajores-forno.celo-testnet.org",
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        // celo: {
        //     url: "https://forno.celo.org",
        //     accounts: [process.env.PRIVATE_KEY],
        // },
        testnet: {
      // HashIO testnet endpoint from the TESTNET_ENDPOINT variable in the .env file
      url: process.env.TESTNET_ENDPOINT,
      // Your ECDSA account private key pulled from the .env file
      accounts: [process.env.TESTNET_OPERATOR_PRIVATE_KEY],
    },
    },
    // etherscan: {
    //     apiKey: {
    //         alfajores: process.env.CELOSCAN_API_KEY,
    //         celo: process.env.CELOSCAN_API_KEY,
    //     },
    //     customChains: [
    //         {
    //             network: "alfajores",
    //             chainId: 44787,
    //             urls: {
    //                 apiURL: "https://api-alfajores.celoscan.io/api",
    //                 browserURL: "https://alfajores.celoscan.io",
    //             },
    //         },
    //         {
    //             network: "celo",
    //             chainId: 42220,
    //             urls: {
    //                 apiURL: "https://api.celoscan.io/api",
    //                 browserURL: "https://celoscan.io/",
    //             },
    //         },
    //     ],
    // },
};
