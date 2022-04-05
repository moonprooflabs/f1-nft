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
    f1_nft = await F1_ContractFactory.deploy("testuri/", 2);
    await f1_nft.deployed();
  })

  it("should deploy the contract", async function() {
    expect(f1_nft.address).to.exist;
  })

  it("should allow owner to change mint amount", async function() {
    await f1_nft.changeMintAmount(3);
    let amount = await f1_nft.max_mint_amount();
  })

  describe("Whitelisting", async function() {
    it("should allow owner to add a user to whitelist", async function() {
      await f1_nft.addToWhiteList([accounts[1].address]);
      let whiteList = await f1_nft.whiteListAddresses(accounts[1].address)
      let nonWhiteList = await f1_nft.whiteListAddresses(accounts[2].address)
      expect(whiteList).to.be.true
      expect(nonWhiteList).to.be.false
    })

    it("should revert if non-owner tries to add a user to the whitelist", async function() {
      await expect(f1_nft.connect(accounts[1]).addToWhiteList([accounts[2].address])).to.be.reverted;
    })

  })
  
  describe("WhiteList Mint", async function() {
    it("should revert if a user tries to mint while it is not the whitelist phase", async function() {
      await f1_nft.addToWhiteList([accounts[1].address]);
      await expect(f1_nft.connect(accounts[1]).mint(1)).to.be.reverted;
    })

    it("should allow a whitelisted user to mint during whitelist phase", async function() {
      await f1_nft.addToWhiteList([accounts[1].address])
      await f1_nft.toggleOn();
      await f1_nft.connect(accounts[1]).mint(1)

      let owner = await f1_nft.ownerOf(1)
      expect(owner).to.eq(accounts[1].address)
    })

    it("should not allow a user to mint more than the max amount", async function() {
      await f1_nft.addToWhiteList([accounts[1].address])
      await f1_nft.toggleOn();
      await f1_nft.connect(accounts[1]).mint(1)

      let owner = await f1_nft.ownerOf(1)
      expect(owner).to.eq(accounts[1].address)

      await f1_nft.connect(accounts[1]).mint(1)

      owner = await f1_nft.ownerOf(2)
      expect(owner).to.eq(accounts[1].address)

      await expect(f1_nft.connect(accounts[1]).mint(1)).to.be.reverted
      
    })

    it("should not allow a user who is not on the whitelist to mint, while it is the whitelist phase", async function() {
      await f1_nft.toggleOn();
      await expect(f1_nft.connect(accounts[1]).mint(1)).to.be.reverted;
    })
  })


  describe("IPFS Check", async function() {
    it("should properly assign tokenURI ", async function() {
      await f1_nft.addToWhiteList([accounts[1].address])
      await f1_nft.toggleOn();
      await f1_nft.connect(accounts[1]).mint(1);

      let owner = await f1_nft.ownerOf(1)
      expect(owner).to.eq(accounts[1].address)

      let uri = await f1_nft.tokenURI(1);
      let uriMap = await f1_nft.uriMap(1)
      expect(uri).to.eq(uriMap);
    })

  })
})