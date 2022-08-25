const hre = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log(`Address deploying the contract --> ${deployer.address}`);

    const NFT = await ethers.getContractFactory("kokoNFT");
    const nft = await NFT.deploy();

    await nft.deployed();

    console.log("kokoNFT deployed to:", nft.address);
}

main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
})

