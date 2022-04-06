require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");

const API_URL = process.env.API_URL; 
const API_KEY = process.env.API_KEY; 
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const IFP_ENDPOINT = process.env.IFP_ENDPOINT;
const WHITE_LIST_ADDR = process.env.WHITE_LIST_ADDR;

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

task("deploy", "Deploy the smart contracts", async(taskArgs, hre) => {

  const accounts = await hre.ethers.getSigners();
  const F1_NFT = await hre.ethers.getContractFactory("F1_NFT");
  const f1_NFT = await F1_NFT.deploy(1, 2, "ipfs://QmY3SBygbfzZo4TxsGER7ya5LfX7eiDKzRKzbnEDKGaLUz");
  await f1_NFT.deployed();

  console.log("Deployed");
  console.log("Address: ", f1_NFT.address);
})

task("mint", "mint Formula 1 NFT", async(taskArgs, hre) => {

  const accounts = await hre.ethers.getSigners();
  const F1_NFT = await hre.ethers.getContractFactory("F1_NFT");
  const f1_NFT = await F1_NFT.deploy(5, 10);

  await f1_NFT.deployed();

  console.log("Deployed");

  
  await f1_NFT.addToWhiteList([WHITE_LIST_ADDR])
  await f1_NFT.mint(1, {value: ethers.utils.parseEther("0.0000000001"), gasLimit: 250000});
  console.log("minted...")
})

module.exports = {
  solidity: "0.8.9",
  gasReporter: {
		enabled: true,
		currency: "USD",
	},
  //  defaultNetwork: "rinkeby",
  //  networks: {
  //      hardhat: {
  //        chainId: 1337
  //      },
  //      rinkeby: {
  //        url: API_URL,
  //        accounts: [`0x${PRIVATE_KEY}`]
  //      }
  //  },
  //  etherscan: {
  //    apiKey: API_KEY,
  //  }
};