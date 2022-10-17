import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("GoodSamaritan Test", function () {
    it("Should drain the GoodSamaritan Wallet", async function() {
        const [OWNER, HACKER] = await ethers.getSigners();
        const GoodSamaritan = await ethers.getContractFactory("GoodSamaritan");
        const goodSamaritan = await GoodSamaritan.deploy();
        await goodSamaritan.deployed();

        const HackerSamaritan = await ethers.getContractFactory("HackerSamaritan");
        const hackerSamaritan = await HackerSamaritan.connect(HACKER).deploy();
        await hackerSamaritan.deployed();

        const Wallet = await ethers.getContractFactory("Wallet");
        const wallet = Wallet.attach(await goodSamaritan.wallet());

        const Coin = await ethers.getContractFactory("Coin");
        const coin = Coin.attach(await goodSamaritan.coin());

        await hackerSamaritan.connect(HACKER).hack(goodSamaritan.address);
        expect(await coin.balances(wallet.address)).to.eq(ethers.constants.Zero);

    })
});
