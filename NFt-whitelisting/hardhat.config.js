require("@nomiclabs/hardhat-waffle");
require("dotenv").config();




const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: process.env.RINKEBY_URL,
      accounts: [`${RINKEBY_PRIVATE_KEY}`]
    }
  }
};