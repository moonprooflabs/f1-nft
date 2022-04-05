// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @author The MoonProof Team - Ken Miyachi, Darian Chan 
/// @title A Contract for F1 DAO NFT
contract F1_NFT is ERC721 {
    address public owner;
    string public baseURI; 
    string public baseExtension = ".json";
    uint256 public  max_mint_amount;
    mapping(address => bool) public whiteListAddresses;
    mapping(address => uint256) public addressTokenCount;
    mapping(uint256 => string) public uriMap;
    uint256 public tokenID = 1; // do we need to start this at 1?

    bool public active; // default value is false

    constructor(
        string memory _newBaseURI,
        uint _max_mint_amount
    ) ERC721("f1_DAO", "f1") {
        owner = msg.sender;
        max_mint_amount = _max_mint_amount;
        setBaseURI(_newBaseURI);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can perform this action");
        _;
    }

    /// @dev toggle mint on or off
    function toggleOn() public onlyOwner {
        active = true;
    }

    function toggleOff() public onlyOwner {
        active = false;
    }

    // ------------------------ //
    //  WHITELIST FUNCTIONALITY //
    // -----------------------  //

    /// @param addresses - List of address to add to the whiteList
    /// @dev adds lists of addresses which can mint tokens in whitelist phase. 
    function addToWhiteList(address[] calldata addresses) public onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whiteListAddresses[addresses[i]] = true;
        }
    }


    /// @param nftAmountToMint - # of NFTs specified to mint
    /// @dev mints tokens to wallet addresses 
    function mint(uint256 nftAmountToMint) public payable {
      checkWhiteListRequirements(nftAmountToMint, msg.sender);
      
      for (uint256 i = 0; i < nftAmountToMint; i++) {
          _mint(msg.sender, tokenID);
          uriMap[tokenID] = tokenURI(tokenID);
          addressTokenCount[msg.sender]++;
          tokenID++;
      }
    }

    // -----------  //
    //   HELPERS   //
    // ---------- //


    /// @param nftAmountToMint - # of NFTs specified to mint
    /// @param user - address of the user minting tokens
    /// @dev checks requirements for whitelist phase mint
    function checkWhiteListRequirements(
        uint256 nftAmountToMint,
        address user
    ) private view {
        require(active == true, "Mint is not on");
        require(
            whiteListAddresses[user] == true,
            "user address is not on whitelist"
        );
        require(addressTokenCount[user] + nftAmountToMint <= max_mint_amount, "Account Address reached limit on Tokens");
        require(
            IERC721(address(this)).balanceOf(user) <= max_mint_amount,
            "max amount you can have is 2 nfts"
        );
    }

    function changeMintAmount(uint amount) public onlyOwner {
        max_mint_amount = amount;
    }

    // ----------------------------- //
    //  IPFS/OPEANSEA FUNCTIONALITY //
    // --------------------------  //

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        Strings.toString(tokenId),
                        baseExtension
                    )
                )
                : "";
    }
}
