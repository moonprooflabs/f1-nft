pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";



/// @author The MoonProof Team - Ken Miyachi, Darian Chan 
/// @title A Contract for F1 DAO NFT
contract F1_NFT is ERC721 {
    address public owner;
    string public baseURI; 
    string public baseExtension = ".json";
    uint256 public constant MAX_WHITELIST_MINT_AMOUNT = 5;
    uint256 public constant MAX_MAIN_MINT_AMOUNT = 8;
    uint256 public whiteListPrice;
    uint256 public mainSalePrice;
    uint256 public constant WHITELIST_NFT_LIMIT = 500; 
    uint256 public constant MAIN_SALE_NFT_LIMIT = 9500;
    mapping(address => bool) public whiteListAddresses;
    mapping(address => uint256) public addressTokenCount;
    mapping(uint256 => string) public uriMap;
    uint256 public tokenID;

    enum Phases {Pre, Whitelist, Main, End} 
    Phases phase; 

    constructor(
        uint256 _whiteListPrice,
        uint256 _mainSalePrice,
        string memory _newBaseURI
    ) ERC721("f1_DAO", "f1") {
        owner = msg.sender;
        whiteListPrice = _whiteListPrice;
        mainSalePrice = _mainSalePrice;
        setBaseURI(_newBaseURI);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can perform this action");
        _;
    }

    // @dev Advances the phase of the mint
    function advancePhase() public onlyOwner {
      phase = Phases(uint(phase) + 1);
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
      require(phase != Phases.Pre, "Minting is not open");
      require(phase != Phases.End, "Minting is closed");
      if (phase == Phases.Whitelist) {
        checkWhiteListRequirements(nftAmountToMint, msg.value, msg.sender);
      }
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
    /// @param amountETHSent - Value of transaction send from msg.sender
    /// @param user - address of the user minting tokens
    /// @dev checks requirements for whitelist phase mint
    function checkWhiteListRequirements(
        uint256 nftAmountToMint,
        uint256 amountETHSent,
        address user
    ) private view {
        require(phase == Phases.Whitelist, "Mint not in Whitelist phase");
        require(
            whiteListAddresses[user] == true,
            "user address is not on whitelist"
        );
        require(addressTokenCount[user] + nftAmountToMint <= 5, "Account Address reached limit on Tokens");

        // TODO: might have to change this if we do a batch mint instead (look into azuki erc721a standard).
        // whiteListMint would only get called once rather than called everytime 1 nft gets minted
        require(amountETHSent >= whiteListPrice, "not enought eth sent");
        require(
            nftAmountToMint <= MAX_WHITELIST_MINT_AMOUNT,
            "can't mint more than 5 nfts during pre-sale"
        );
        require(
            tokenID <= WHITELIST_NFT_LIMIT,
            "no more nfts available for pre-sale"
        );
        require(
            IERC721(address(this)).balanceOf(user) <= MAX_WHITELIST_MINT_AMOUNT,
            "max amount you can have is 5 nfts during pre-sale"
        );
    }

    /// @param nftAmountToMint - # of NFTs specified to mint
    /// @param amountETHSent - Value of transaction send from msg.sender
    /// @param user - address of the user minting tokens
    /// @dev checks requirements for main sale phase mint
    function checkMainSaleRequirements(
        uint256 nftAmountToMint,
        uint256 amountETHSent,
        address user
    ) private view {
        require(amountETHSent >= mainSalePrice, "not enough eth sent");
        require(
            nftAmountToMint <= MAX_MAIN_MINT_AMOUNT,
            "can't mint more than 8 nfts during main sale"
        );
        require(tokenID <= MAIN_SALE_NFT_LIMIT, "all nfts are sold out!");

        require(
            IERC721(address(this)).balanceOf(user) <= MAX_MAIN_MINT_AMOUNT,
            "max amount you can have is 8 nfts during main sale"
        );
    }

    /// @param price - specifies the price for NFT in main sale mint
    /// @dev sets price of NFT during main sale phase
    function setMainSalePrice(uint256 price) public onlyOwner {
        mainSalePrice = price;
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
