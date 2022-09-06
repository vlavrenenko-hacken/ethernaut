import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("GateKeeperTwo Test", function () {
    it("Should set the entrant", async function () {
        const [OWNER, HACKER] = await ethers.getSigners();
        const GateKeeperTwo = await ethers.getContractFactory("GateKeeperTwo");
        const gatekeepertwo = await GateKeeperTwo.deploy();
        await gatekeepertwo.deployed();

        const Hacker = await ethers.getContractFactory("HackerTwo");
        const hackersc = await Hacker.connect(HACKER).deploy(gatekeepertwo.address);
        await hackersc.deployed();
        
        expect(await gatekeepertwo.entrant()).to.eq(HACKER.address);
    });
});
