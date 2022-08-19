const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFT Mint", function() {
  it("Deploy the NFT contract. mint a token, and ensure that we have the right metadata associated with the tokenId", async function() {

    const [owner] = await ethers.getSigners();

    const NFT = await ethers.getContractFactory("SamNFT");
    const nft = await NFT.deploy();
    const URI = "ipfs://QmVn7PkstAfZV8UoFTx1m9JXAJWbRwNi3q2pW2txBN2fTA";
    // const URI = "ipfs://QmQ8J9u43Ah3kp4Fr1eK5PuP5DS2nox9VXWUSDnAJWJ6K4";
    await nft.deployed();
    await nft.mint(owner.address, URI)
    expect(await nft.tokenURI(1)).to.equal(URI);
  });
})
