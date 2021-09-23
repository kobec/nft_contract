const { ethers, upgrades } = require('hardhat');
async function main() {
    // Grab the contract factory
    const SmartNFT2 = await ethers.getContractFactory("SmartNFT2");
    console.log('Deploying Box...');
    // Start deployment, returning a promise that resolves to a contract object
    const smartNFT = await upgrades.deployProxy(SmartNFT2, [42], { initializer: 'store' });

    await smartNFT.deployed(); // Instance of the contract
    console.log("Contract deployed to address:", smartNFT.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });