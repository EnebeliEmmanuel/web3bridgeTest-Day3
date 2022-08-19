const hre = require("hardhat");

async function main() {
    const NFT = await hre.ethers.getContractFactory("kokoNFT");
    const CONTRACT_ADDRESS = "0x34631d0dBbe34E1952E0A63f343Cc5Cd7573F278"
    const contract = NFT.attach(CONTRACT_ADDRESS);

    const owner = await contract.ownerOf(1);
    console.log("Owner:", owner);

    const uri = await contract.tokenURI(1);
    console.log("URI: ", uri);
}
main().then(() => process.exit(0))
        .catch(error => {
            console.error(error);
            process.exit(1);
        })