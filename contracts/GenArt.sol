pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract GenArt is ERC721Enumerable, Ownable {
    
    using Strings for uint256;

    bool public saleIsActive = true;
    uint256 public MAX_SUPPLY = 10000;
    uint256 public ETH_PRICE = 10000000000000000; // 0.01 ETH

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    string[] public colors = [
        "A",
        "B",
        "C",
        "D",
        "E",
        "F",
        "G",
        "H",
        "I",
        "J",
        "K",
        "L",
        "M",
        "N",
        "O",
        "P",
        "Q",
        "R",
        "S"
    ];
    
    string private _baseURIExtended;
    mapping (uint256 => string) tokenColors;

    constructor() public ERC721("GenArt", "GENART") {
        console.log("Token constructor called.");
    }

    function random() private view returns (uint256) {
        uint256 randomHash = uint256(keccak256(abi.encodePacked(block.timestamp - 1996)));
        return randomHash;
    }

    function toggleSaleState() public onlyOwner returns (bool) {
        saleIsActive = !saleIsActive;
        return saleIsActive;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        ETH_PRICE = _price;
    }

    function mint() public payable {
        console.log("Called mint.");

        require(saleIsActive, "Sale is not active at the moment");

        uint256 newId = totalSupply() + 1;
        require(newId <= MAX_SUPPLY, "Purchase would exceed max supply");

        // If sender is buyer, then check eth value
        if (msg.sender != owner()) {
            require(ETH_PRICE <= msg.value, "Ether missing...");
        }

        // Generate random color
        uint256 randNum = random();
        console.log(randNum);

        string memory color = string(abi.encodePacked(colors[uint256(randNum) % 19], colors[uint256(randNum / 10) % 19], colors[uint256(randNum / 100) % 19], colors[uint256(randNum / 1000) % 19], colors[uint256(randNum / 10000) % 19]));
        console.log(color);

        tokenColors[newId] = color;
        _safeMint(msg.sender, newId);
    }

    function getColorId(uint256 tokenId) public view returns (string memory) {
        return tokenColors[tokenId];
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIExtended;
    }

    // Sets base URI for all tokens, only able to be called by contract owner
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIExtended = baseURI_;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
}
