// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;
import "hardhat/console.sol";
interface ICollatz {
  function collatzIteration(uint256 n) external pure returns (uint256);
}


contract HackerCTF {
  function hack(address victim) external {
    bytes memory bytecode = hex'7f6004356002810660165760011c5b60005260206000f35b600302600101600d5660005260206000f3'; // creation code + bytecode (collatzIteration)
    address solver;
    uint salt = 0;
    assembly {
      solver := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
    }
  }

}
contract CollatzPuzzle is ICollatz {
  function collatzIteration(uint256 n) public pure override returns (uint256) {
    if (n % 2 == 0) {
      return n / 2;
    } else {
      return 3 * n + 1;
    }
  }

  function callMe(address addr) external view returns (bool) {
    // check code size
    uint256 size;
    assembly {
      size := extcodesize(addr)
    }
    console.log(size);
    
    require(size > 0 && size <= 32, "bad code size!");

    // check results to be matching
    uint p;
    uint q;
    for (uint256 n = 1; n < 200; n++) {
      // local result
      p = n;
      for (uint256 i = 0; i < 5; i++) {
        p = collatzIteration(p);
      }
      // your result
      q = n;
      for (uint256 i = 0; i < 5; i++) {
        q = ICollatz(addr).collatzIteration{gas: 100}(q);
      }
      require(p == q, "result mismatch!");
    }

    return true;
  }
}
