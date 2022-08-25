//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/// @notice imported contracts from openzepplin to verify proof, to count, to make ownable.
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; // OZ: MerkleProof
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol"; // tokenUri
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


 /// @author kokocodes
 /// @title NFT whitelist
 /// @dev All function calls are currently implemented without side effects
/// @dev Contract emits claimed events in logic

contract NFTWhitelisting is ERC721URIStorage, Ownable {
    //imported from OpenZeppelin
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint256 MAX_SUPPLY = 21;
    /// =================== VARIABLES ================================

    ///@dev root of the MerkleTree
    bytes32 public root = 0xd38a533706a576a634c618407eb607df606d62179156c0bed7ab6c2088b01de9;

    
    /// @notice a mappiing to track addresses that have claimed 
    mapping (address => bool) public claimed;


 ///======================= EVENTS & ERRORS ==============================
    /// guy why na, try and be satisfied
    error AlreadyClaimed();

    /// guy you no dey our list
    error NotWhitelisted();

    /// no valid proof provided
    error notAValidProof();

    /// Sorry, all NFTs have been minted!
    error alreadyMintedAll();

    event Claimed(address indexed claimer, uint256 indexed tokenId);

    constructor() ERC721("kokoNFT", "KOK") {}

// SET FUNCTIONS (CHANGE STATE)
    function claim(bytes32[] calldata proof) internal view returns(bool status) {
    
       if(claimed[msg.sender]){
        revert AlreadyClaimed();
       } 

       // verify merkle proof
       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
       bool isValid = MerkleProof.verify(proof, root, leaf);
       if(!isValid) revert  NotWhitelisted();

       status = true;

       
    }

   function safeMint(string memory uri, bytes32[] calldata proof) public{

        bool stat = claim(proof);
        
           if(!stat){
            revert notAValidProof();
        }
       


        uint256 tokenId = _tokenIds.current();
        if(tokenId >= MAX_SUPPLY){
            revert alreadyMintedAll();
        }
        _tokenIds.increment();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        claimed[msg.sender] = true;

        emit Claimed(msg.sender, tokenId);
    }

}