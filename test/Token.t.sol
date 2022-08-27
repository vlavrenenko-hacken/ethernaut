// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/Token.sol";
import "forge-std/Test.sol";

contract TokenTest is Test {
    Token private token;
    address private constant HACKER = address(0x1);

    function setUp() external {
        token = new Token(1e6);
        token.transfer(HACKER, 20);

        vm.deal(HACKER, 2e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        token.transfer(HACKER, 1e5);
        assertEq(HACKER.balance, 2000000000000000000);
    }
    
}