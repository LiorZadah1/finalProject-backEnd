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
  await votingSystem.deployed(); // This line waits for the contract to be deployed

  console.log("VotingSystem deployed to:", votingSystem.address);

  // Load user data
  const users = JSON.parse(fs.readFileSync('users.json', 'utf8'));
  // Save deployed contract address to users.json
  users.forEach(user => {
    user.contractAddress = votingSystem.address;
  });
  fs.writeFileSync('users.json', JSON.stringify(users, null, 2));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
