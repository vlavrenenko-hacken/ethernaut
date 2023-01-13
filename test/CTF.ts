import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("CTF Test", function () {
    it("Should hack CTF", async function () {
        const [OWNER] = await ethers.getSigners();
        const HACKERCTF = await ethers.getContractFactory("HackerCTF");
        const hackerCTF = await HACKERCTF.deploy();
        await hackerCTF.deployed();

        const CollatzPuzzle = await ethers.getContractFactory("CollatzPuzzle");
        const collatzPuzzle = await CollatzPuzzle.deploy();
        await collatzPuzzle.deployed();

        await hackerCTF.connect(OWNER).hack(collatzPuzzle.address);
    });
});