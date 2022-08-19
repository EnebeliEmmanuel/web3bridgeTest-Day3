const hre = require("hardhat");

async function main() {
    const NFT = await hre.ethers.getContractFactory("kokoNFT");
    const CONTRACT_ADDRESS = "0xE38D1241488c29eB35262aaa87F5f8E4205d6E2C"
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