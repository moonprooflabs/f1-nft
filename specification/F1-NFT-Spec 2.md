# F1 NFT Specification 

## Motivation 

F1 DAO is launching a platform for super fans to rally around a singular mission: Buy a F1 Team. The first step in this process is to build a Formula 1 DAO Membership NFT. A Formula 1 DAO Membership NFT that will grant you exclusive rights and benefits as a holder. 

## Use-Case

All NFT holders will be airdropped $POINTS governance tokens when we launch in Mid 2022. Some other potential benefits include: events and parties hosted at F1 race events, special behind the scenes access with F1 drivers,  virtual watch parties hosted in discord, and more. We’d love to hear from the community (YOU) and what benefits you’d like to see - hop in the discord and let us know.

## Requirements

  #### Pre-Sale:
  - Whitelisting ability for pre-sale 
    - suggest to do this off chain. i.e get whitelisted in a discord, have them fill out a google form with their wallet address, then we'll whitelist everyone at once. Saves gas
  - max of 5 NFT mint per wallet in pre-sale
    - what's the price for whitelisted mints?
    - is there a cap to the pre-sale? If 10k people sign up for the whitelist, are you going to let all 10k get minted?
    - can also create a function to make it dynamic if you don't know yet, but will cost you gas everytime you want to change it

  #### Main Sale:
  - max of 8 nft mint per wallet
    - if a user minted 5 nfts in the whitelisted presale, can they also mint 8 more nfts in the main sale?
  - ability to have different price for presale and main sale as well 
    - what's the price for the main sale?
    - can also create a function to make it dynamic if you don't know yet, but will cost you gas everytime you want to change it

  #### Other Features:
  - Ability to make one of one NFTs that are in addition to the 10,000 launch (i.e. we make a custom car NFT for lewis hamilton after mint)
    - we just won't put a hard 10k cap on the nft contract itself so we can add additional token id's to the collection if necessary
  - Ability to send airdrops to NFT holders
    - we can do this later on seperately. Will need to create a new erc20 contract. Then take a snapshot at a specific block and for every wallet that owns an F1 at that snapshot, we will airdrop erc20 tokens to them. (will need to look into merkel tree airdrop to do this)
  - 5% of NFTs reserved for team to promote and use to airdrop for marketing purposes
    - will put a pre sale + main sale cap limit at 9500 (reserve 500 nfts for team + marketing)
  - 5% of secondary sales are given back to f1dao (i think this is opensea functionality) 
    - need to look into it more, but yea think you can just specify the % royalties through opensea. That's why some people have been saying the royalties technically aren't enforcable because it's not done through the smart contract
  - Any other things we may need to implement to prevent us from being botted (bots purchase all nfts before real people can) 
    - look into this more - pretty important edge case
  - Deploy contract on testnet and opensea testnet first
    - we can use rinkeby testnet and test on opensea
  - I don't think we want to do this, but any thoughts around a reveal functionality of the NFT?   
    - need to look into it more. I think it's probably something with hiding/revealing the metadata. ie. hide metadata when the nft gets minted at first, and then at a specific time do a metadata reveal

  #### Minting DApp:
  - Ability to engage with Metamask 
    - get wallet address and take in a signature
  - whatever needs to happen to remain uptime for a mass audience mint and not crash 
  - Frontend of website - do you know of any great frontend web designers?
    - Not too sure, will have to look around. I know react on the frontend but definitley am not a good designer at all - will need someone else to handle this

## Architecture

#### ERC-721

Different use cases can require the utilization of different NFT standards. Internally, the F1DAORegistry integrates with this token implementation allowing full assets tokenization without further requirements.

In addition to this, for asset owners with already deployed ERC-721 contracts, these external contracts can be integrated as part of the selling and accessing flows allowing the purchase of ERC-721 based NFTs and access to exclusive contents for the NFT holders.


```
await didRegistry.registerMintableDID(
                didSeed, checksum, [], url, cappedAmount, royalties, constants.activities.GENERATED, '')
await didRegistry.mint(did, 5)
await didRegistry.burn(did, 1)
await didRegistry.balanceOf(someone, did)
```

The registerMintableDID is a new method that facilitates a couple new things for users registering assets who want to attach a NFT to them:

They enable the NFT functionality for the asset registered. By default, the assets registered via the registerDID method do not have the NFTs functionality enabled.
It setups a minting cap for the asset
It specify the percentage of royalties (between 0 and 100) that the original creator of the Asset wants in the secondary market for a further sale.
When a DID is registered via the traditional registerDID method, the same functionality can be obtained calling the enableAndMintDidNft method. Example:
```
const did = await didRegistry.registerAttribute(didSeed, checksum, [], url)
await didRegistry.enableAndMintDidNft(did, 5, 0, true)
```

#### Flows

**TODO** Flow Diagram NFT Airdrop

**TODO** Flow Diagram of NFT to DAO Membership 

#### Token Structure

Metadata (Standard) 
```
{
  "name": "F1 Car #1",
  "description": "F1 CAR NFT used for F1 DAO Membership",
  "image": "ipfs://bafybeict2kq6gt4ikgulypt7h7nwj4hmfi2kevrqvnx2osibfulyy5x3hu/no-time-to-explain.jpeg"
}
```