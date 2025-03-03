async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
  
    const fetToken = "0x3A54192862D1c52C8175d4912f1f778d1E3C2449";
    const rejuveToken = "0x0d5585bA627146BD27081099C75260DA7086f682";
  
    const Faucet = await ethers.getContractFactory("FaucetV1");
  
    const faucet = await Faucet.deploy(
        fetToken,
        rejuveToken
    );
  
    console.log("Contract deployed", await faucet.getAddress());
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });