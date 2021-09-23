async function main() {
    // Grab the contract factory
    const SNFT = await ethers.getContractFactory("SNFT");

    // Start deployment, returning a promise that resolves to a contract object
    const sNFT = await SNFT.deploy(); // Instance of the contract
    console.log("Contract deployed to address:", sNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });