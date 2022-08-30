import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("AlienCodex Test", function () {
    it("Should claimOwnerShip", async function() {
        const [OWNER, HACKER] = await ethers.getSigners();
        const AlienCodex = await ethers.getContractFactory("AlienCodex");
        const alienCodex = await AlienCodex.connect(OWNER).deploy();
        await alienCodex.deployed();

        await alienCodex.connect(HACKER).make_contact();
        expect(await alienCodex.contact()).to.be.true;
        // console.log(await ethers.provider.getStorageAt(alienCodex.address, ethers.utils.hexZeroPad("0", 32)));
    })
});
