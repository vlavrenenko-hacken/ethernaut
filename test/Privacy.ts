import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("Privacy Test", function () {
    it("Should unlock", async function() {
        const [OWNER, HACKER] = await ethers.getSigners();
        const Privacy = await ethers.getContractFactory("Privacy");
        const privacy = await Privacy.deploy([utils.formatBytes32String("10"), utils.formatBytes32String("18"), utils.formatBytes32String("289")]);
        await privacy.deployed();

        // const slot = ethers.utils.keccak256("3") + 3;
        const key = await ethers.provider.getStorageAt(privacy.address, utils.hexZeroPad(ethers.BigNumber.from(5).toHexString(), 32));
        await privacy.unlock(key.slice(0, 34));
        expect(await privacy.locked()).to.be.false;
    })
});
