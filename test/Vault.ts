import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("Vault Test", function () {
    it("Should unlock the vault", async function () {
        const [OWNER, HACKER] = await ethers.getSigners();
        const Vault = await ethers.getContractFactory("Vault");
        const vault = await Vault.connect(OWNER).deploy(utils.formatBytes32String("pwd996222"));
        await vault.deployed();

        const password = await ethers.provider.getStorageAt(vault.address, 1);
        await vault.connect(HACKER).unlock(password);
        expect(await vault.locked()).to.be.false;
    });
});