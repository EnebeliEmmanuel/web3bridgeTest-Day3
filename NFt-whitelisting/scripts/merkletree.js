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

    // printing the merkle tree on the console
    console.log('Whitelist Merkle Tree\n', merkleTree.toString());
    console.log("Root Hash: ", rootHash);


    // Important things to take note is the => (
    // User address, the proof (this would be gotten using the merkle tree object) and the root hash
    // )

    // Here is the user story, the user who is coming with an address (msg.sender) whi call the backend, then the backend return the proof 

}


// const claimingAddress = leafNodes[6];
// const hexProof = merkleTree.getHexProof(claimingAddress);
// console.log(hexProof);
// console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });