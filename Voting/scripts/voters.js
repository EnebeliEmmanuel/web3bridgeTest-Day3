const { MerkleTree } = require('merkletreejs')
const keccak256 = require('keccak256')

console.log("the merkleTree is loading.................................")

let stakeholders = [
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB","0x617F2E2fD72FD9D5503197092aC168c91465E7f2"
]

// this creates a new array "leafnodes" by hashing the index of all stakeholders addresses using keccak256
//then we create a merkletree object 
const leafnodes = stakeholders.map(addr => keccak256(addr))

const merkleTree = new MerkleTree(leafnodes, keccak256, {sortPairs: true})

const rootHash = merkleTree.getRoot()

console.log("stakeholder's merkle tree\n", merkleTree.toString())

const test = keccak256("0x617F2E2fD72FD9D5503197092aC168c91465E7f2")

const hexProof = merkleTree.getHexProof(test);

const buf2hex = x => '0x' + x.toString('hex')

console.log("this is the root\n", buf2hex(rootHash))
console.log("this is the proof\n", hexProof)

console.log("testing a scenario")
console.log(merkleTree.verify(hexProof,test,rootHash))