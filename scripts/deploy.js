async function main() {
    // Grab the contract factory
    const SmartNFT = await ethers.getContractFactory("SmartNFT");

    // Start deployment, returning a promise that resolves to a contract object
    const smartNFT = await SmartNFT.deploy(); // Instance of the contract
    console.log("Contract deployed to address:", smartNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });