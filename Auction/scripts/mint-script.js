const hre = require("hardhat");

async function main() {
    const NFT = await hre.ethers.getContractFactory("kokoNFT");

    // The IPFS Address of image uploaded to Pinata
   
    const URI = "https://ipfs.io/ipfs/QmRd3619b1Qvoknyf69fYD7d33XZZVSAu9XKpTKtCZrFgk"

    // Wallet Address
    const WALLET_ADDRESS = "0x20497F37a8169c8C9fA09411F8c2CFB7c90dE5d1"

    // Contract address deployed
    const CONTRACT_ADDRESS = "0xE38D1241488c29eB35262aaa87F5f8E4205d6E2C"

    const contract = NFT.attach(CONTRACT_ADDRESS);
    await contract.mint(WALLET_ADDRESS, URI);
    console.log("NFT minted:", contract);
}

main().then(() => process.exit(0))
      .catch(error => {
          console.error(error);
          process.exit(1);
      })