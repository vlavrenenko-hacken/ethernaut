// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/Fallback.sol";


contract LockTest is Test {
    Lock private lock;
    address private constant ALICE = address(0x1);
    uint private UNLOCKTIME = block.timestamp + 10 * 24* 3600; // in 10 days
    function setUp() external {
        vm.deal(ALICE, 10e18);
        vm.startPrank(ALICE);
        lock = (new Lock){value: 2e18}(UNLOCKTIME);
    }

    function testWithdraw() external {
        vm.warp(UNLOCKTIME + 11); // 11 days
        (bool success, ) = address(lock).call(abi.encodeWithSignature("withdraw()"));
        require(success, "tx failed");
        vm.stopPrank();
        assertEq(address(lock).balance, 0);
    }
}