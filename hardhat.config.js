require("@nomiclabs/hardhat-waffle");

const RINKEBY_INFURA_KEY= "b5bf9c37aa8d42c8b48e27d45a10c8d3";
const RINKEBY_PRIVATE_KEY = "226775b3a4d2049c088d9f59b0c897a77dbbb90e7bf3f7ee9f4145310da3e45a";

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${RINKEBY_INFURA_KEY}`,
      accounts: [`0x${RINKEBY_PRIVATE_KEY}`],
      gas: 5500000
    }
  },
};
