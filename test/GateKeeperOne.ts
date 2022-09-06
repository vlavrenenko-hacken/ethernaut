import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("GateKeeperOne Test", function () {
    it("Should set the entrant", async function () {
        const [OWNER, HACKER] = await ethers.getSigners();
        const GateKeeperOne = await ethers.getContractFactory("GateKeeperOne");
        const gatekeeperone = await GateKeeperOne.deploy();
        await gatekeeperone.deployed();

        const Hacker = await ethers.getContractFactory("Hacker");
        const hackersc = await Hacker.deploy();
        await hackersc.deployed();
         // HACKER 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 && 0xfFFFfFfffFfFFfFFfffFffFFFffffFFF0000ffff
         // MASKED VALUE 0x70997970c51812dc3a010c7d01b50e0d000079c8
         // 1) uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
         // 0x01b50e0d000079c8(64 bits)
         // 0x000079c8(32 bits) = 79c8(16 bits)
         // 2) uint32(uint64(_gateKey)) != uint64(_gateKey)
         // 0x000079c8 != 0x01b50e0d000079c8
         // 3) uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
         //    0x000079c8 == 0x79C8
        const MOD = 8191
        const gasToUse = 758130;
        for(let i = 1; i < 40; i++) {
            // console.log(`testing ${gasToUse + i*MOD}`)
            await hackersc.attack(gatekeeperone.address, gasToUse + i*MOD, {
            gasLimit: `2000000`
            });
        }
        expect(await gatekeeperone.entrant()).to.eq(HACKER.address);
    });
});
