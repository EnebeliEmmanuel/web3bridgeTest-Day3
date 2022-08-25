const hre = require("hardhat");
const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

// 0X5B38DA6A701C568545DCFCB03FCB875F56BEDDC4

async function main() {
    console.log("Obtaining the addresses for hardhat");
    let whiteListedAddresses = await hre.ethers.getSigners();

    // Using keccak256 hashing algorithm to hash the leavves of the trees
    const leaf_nodes = whiteListedAddresses.map(signer => keccak256(signer.address)); //this line of code would handle all the hashing

    // now creating the merkle tree object
    const merkleTree = new MerkleTree(leaf_nodes, keccak256, { sortPairs: true});

    // obtaining the root hash
    const rootHash = merkleTree.getHexRoot();

    const claimingAddress = leaf_nodes[0];
    
    const hexProof = merkleTree.getHexProof(claimingAddress);
    // console.log(hexProof);


    // Making the call to the smart contract
    const Airdrop = await hre.ethers.getContractFactory("NFTWhitelisting");
    const airdrop = await Airdrop.deploy();
    await airdrop.deployed();

    await airdrop.safeMint( "https://gateway.pinata.cloud/ipfs/QmRHZdqF6rRyEtvt3pDHjY4jJ9Zd1kHFtESgUuHBtWwan3", hexProof);

    const tokenID = await airdrop.tokenURI(0);

    console.log(tokenID);
    




}



main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });