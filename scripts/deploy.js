const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  
  /////////////// @DEV MAKE SURE THE '/' IS AT THE END OF THE URL WHEN DEPLOYING ///////////////
  const f1_nftFactory = await ethers.getContractFactory("F1_NFT")
  const f1_nft = await f1_nftFactory.deploy("https://gateway.pinata.cloud/ipfs/Qmc83EFeq9jnFxksn8kG4CZoCy5r8kw9Mn4fGapMwoWZwe/", 2)
  
  console.log("test nft deployed to:", f1_nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

