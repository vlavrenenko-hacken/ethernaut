import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("DoubleEntryPoint Test", function () {
    it("Should prevent CryptoVault from being hacked", async function() {
        const [OWNER, SWEPT_TOKENS_RECIPIENT] = await ethers.getSigners();

        const CryptoVault = await ethers.getContractFactory("CryptoVault");
        const cryptoVault = await CryptoVault.deploy(SWEPT_TOKENS_RECIPIENT.address);
        await cryptoVault.deployed();

        
        const DetectionBot = await ethers.getContractFactory("DetectionBot");
        const detectionBot = await DetectionBot.deploy(cryptoVault.address);
        await detectionBot.deployed();


        const Forta = await ethers.getContractFactory("Forta");
        const forta = await Forta.deploy();
        await forta.deployed();
        
        await forta.setDetectionBot(detectionBot.address);

        const LegacyToken = await ethers.getContractFactory("LegacyToken");
        const legacyToken = await LegacyToken.deploy();
        await legacyToken.deployed();

        await legacyToken.mint(cryptoVault.address, ethers.utils.parseEther("100"));

        // CryptoVault has 100 LGT and 100 DET
        const DoubleEntryPoint = await ethers.getContractFactory("DoubleEntryPoint");
        const doubleEntryPoint = await DoubleEntryPoint.deploy(legacyToken.address, cryptoVault.address, forta.address, OWNER.address);
        await doubleEntryPoint.deployed();
        await legacyToken.delegateToNewContract(doubleEntryPoint.address);
        await expect(cryptoVault.sweepToken(legacyToken.address)).to.be.revertedWith("Alert has been triggered, reverting");

    })
});
