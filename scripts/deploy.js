const hre = require("hardhat");

async function main() {
  const SimpleAuction = await hre.ethers.getContractFactory("SimpleAuction");

  // Set auction duration: e.g., 300 seconds (5 minutes)
  const biddingTimeInSeconds = 300;
  const simpleAuction = await SimpleAuction.deploy(biddingTimeInSeconds);

  await simpleAuction.deployed();

  console.log("SimpleAuction deployed to:", simpleAuction.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
