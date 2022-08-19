const hre = require("hardhat");

async function main() {
    const NFT = await hre.ethers.getContractFactory("kokoNFT");

    // The IPFS Address of image uploaded to Pinata
   
    const URI = "https://ipfs.io/ipfs/QmUZVHapkM7VRMrxmMXJz6mW38tnePoqQuvgpJ8CV67n7C"

    // Wallet Address
    const WALLET_ADDRESS = "0x20497F37a8169c8C9fA09411F8c2CFB7c90dE5d1"

    // Contract address deployed
    const CONTRACT_ADDRESS = "0x34631d0dBbe34E1952E0A63f343Cc5Cd7573F278"

    const contract = NFT.attach(CONTRACT_ADDRESS);
    await contract.mint(WALLET_ADDRESS, URI);
    console.log("NFT minted:", contract);
}

main().then(() => process.exit(0))
      .catch(error => {
          console.error(error);
          process.exit(1);
      })