// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "src/DoubleEntryPoint.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract DoubleEntryPointTest is Test {
    LegacyToken private legacyToken;
    DoubleEntryPoint private doubleEntryPointToken;
    CryptoVault private cryptoVault;
    Forta private forta;
    DetectionBot private detectionBot;
    address private constant SWEPT_TOKENS_RECIPIENT = address(0x3);
    address private constant PLAYER = address(0x4);
    function setUp() external {
        cryptoVault = new CryptoVault(SWEPT_TOKENS_RECIPIENT);
        legacyToken = new LegacyToken();
        forta = new Forta();
        doubleEntryPointToken = new DoubleEntryPoint(address(legacyToken), address(cryptoVault), address(forta), PLAYER);
        detectionBot = new DetectionBot();
        forta.setDetectionBot(address(detectionBot));

        // 100 LGT to CryptoVault
        legacyToken.mint(address(cryptoVault), 100e18);

        cryptoVault.setUnderlying(address(doubleEntryPointToken));
        // find the bug in CryptoVault protect
        


    }

}

contract DetectionBot is IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external {

    }
}