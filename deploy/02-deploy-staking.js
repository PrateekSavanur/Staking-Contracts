const { ethers } = require("hardhat")
const { verify } = require("../utils/verify")
const { developmentChains, VERIFICATION_BLOCK_CONFIRMATIONS } = require("../helper-hardhat-config")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()
    const waitBlockConfirmations = developmentChains.includes(network.name)
        ? 1
        : VERIFICATION_BLOCK_CONFIRMATIONS

    const utilityToken = await deployments.get("UtilityToken")
    const stableToken = await deployments.get("StableToken")

    const args = [utilityToken.address, stableToken.address]

    const stakingDeployment = await deploy("Staking", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: waitBlockConfirmations,
    })

    console.log(
        "......................................................................................",
    )
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        console.log("Verifying...")
        await verify(stakingDeployment.address, args)
    }
}

module.exports.tags = ["all", "staking"]
