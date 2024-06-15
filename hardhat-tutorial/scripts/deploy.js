// //function to discover the address of the contract
// async function main() {
//     const [deployer] = await ethers.getSigners();
  
//     console.log("Deploying contracts with the account:", deployer.address);
//     console.log("Account balance:", (await deployer.getBalance()).toString());
  
//     const Contract = await ethers.getContractFactory("VotingSystem");
//     const contract = await Contract.deploy(); // Add constructor arguments if there are any
  
//     console.log("Contract deployed to:", contract.address);
//   }
  
//   main().catch((error) => {
//     console.error(error);
//     process.exitCode = 1;
//   });
  
const { ethers } = require("hardhat");
const fs = require('fs');

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const VotingSystem = await ethers.getContractFactory("VotingSystem");
  const votingSystem = await VotingSystem.deploy();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
