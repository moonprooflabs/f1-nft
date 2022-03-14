const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = ethers;

describe("F1_NFT", function() {
  let F1_ContractFactory;
  let f1_nft;
  let accounts;

  beforeEach(async function() {
    accounts = await ethers.getSigners();

    F1_ContractFactory = await ethers.getContractFactory("F1_NFT")
    f1_nft = await F1_ContractFactory.deploy(5, 10);
    await f1_nft.deployed();
  })
  it("should deploy the contract", async function() {
    expect(f1_nft.address).to.exist;
  })

  describe("Whitelisting", async function() {
    it("should allow owner to add a user to whitelist", async function() {
      await f1_nft.addToWhiteList([accounts[0].address]);
      let whiteList = await f1_nft.whiteListAddresses(accounts[0].address)
      expect(whiteList).to.be.true
    })
    it("should revert if non-owner tries to add a user to the whitelist", async function() {
      // await expect(f1_nft.connect(accounts[1]).addToWhiteList([accounts[0]].address));

    })
  })
  
  
  describe("Main Sale Mint", async function() {
    it("should allow a whitelisted user to mint", async function() {
      await f1_nft.addToWhiteList([accounts[0].address])
      await f1_nft.mainSaleMint(1, {value: ethers.utils.parseEther("10")});
      let owner = await f1_nft.ownerOf(0)
      expect(owner).to.eq(accounts[0].address)
    })

    it("should not allow a user not on the whitelist to mint", async function() {
      await expect(f1_nft.mainSaleMint(1, {value: ethers.utils.parseEther("10")})).to.be.reverted;
    })
  })


  describe("IPFS Check", async function() {
    it("should properly assign tokenURI ", async function() {
      await f1_nft.addToWhiteList([accounts[0].address])
      await f1_nft.mainSaleMint(1, {value: ethers.utils.parseEther("10")});
      let owner = await f1_nft.ownerOf(0)
      expect(owner).to.eq(accounts[0].address)
      let uri = await f1_nft.getTokenURI(0);
      let mapUri = await f1_nft.uriOf(0);
      expect(uri).to.eq('ipfs://QmeaMoYkPYqQBHEkgrXibDcwp6Eo4VjEKWSzWBXQMNC7Cy/0.json');
      expect(uri).to.eq(mapUri);
    })

  })
})