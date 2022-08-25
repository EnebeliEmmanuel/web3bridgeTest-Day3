// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract kokoNFT is ERC721, Ownable {

  //imported from OpenZeppelin
  using Counters for Counters.Counter;
  using Strings for uint256;

  Counters.Counter private _tokenIds;
  mapping (uint256 => string) private _tokenURIs;
  constructor() ERC721("kokoNFT", "KOK") {
  }

//Sets the metadata associated with the token. The metadata will be the ipfs hash. 
  function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual
  {
    _tokenURIs[tokenId] = _tokenURI;
  }

  //grabs the tokenURI for the tokenid. effectively grabbing the metadata.
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
  {
    require(_exists(tokenId), "The MetaData for this tokenId does not exist in this contract");
    string memory _tokenURI = _tokenURIs[tokenId];
    return _tokenURI;
  }

//mints a token by taking the metadata passed into the uri, 
//and associated that metadata with the recipients address.
  //next we assign the uri metadata to the tokenId.
  function mint(address recipient, string memory uri) public returns (uint256)
  {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _mint(recipient, newItemId);
    _setTokenURI(newItemId, uri);
    return newItemId;
  }
}