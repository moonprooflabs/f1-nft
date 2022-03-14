const { ethers } = require("hardhat");

async function main() {
  // deploy the coveredCall contract
  const f1_nftFactory = await ethers.getContractFactory("F1_NFT")
  const f1_nft = await f1_nftFactory.deploy(ethers.utils.parseEther(".1"), ethers.utils.parseEther(".2"), "https://gateway.pinata.cloud/ipfs/QmToXqD4YkZfJd8BxLq9JEhFV5zqcZKyV5pjSsfuyYqRxu/")
  console.log("test nft deployed to:", f1_nft.address);
  
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

