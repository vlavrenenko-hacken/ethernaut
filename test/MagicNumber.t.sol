// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "src/MagicNumber.sol";
import "forge-std/console.sol";
import "forge-std/Test.sol";

contract MagicNumTest is Test {
    MagicNum private magicn;
    function setUp() external {
        magicn = new MagicNum();
    }

    function testHack() external {

        // 602a60005260206000f3
        bytes memory bytecode = hex"69602A60005260206000F3600052600A6016F3";
        address solver;
        bytes32 salt = 0;
        assembly {
            solver := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        magicn.setSolver(solver);
        (bool result, bytes memory data) = solver.call(abi.encodeWithSignature("fallback()"));
        assertEq(abi.decode(data, (uint)), 42);
        
    }
}

//602a    // v: push1 0x2a (value is 0x2a)
//6000    // p: push1 0x00 (memory slot is 0x00)
// 52      // mstore
// 6020    // s: push1 0x20 (value is 32 bytes in size)
// 6000    // p: push1 0x00 (value was stored in slot 0x00)
// f3      // return

// bytecode = "602a60005260206000f3"