//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Factory} from "../src/Factory.sol";
import {console} from "forge-std/console.sol";

contract MultiSigTest is Test {
    Factory factory;

    function setUp() external {
        factory = new Factory();
    }

    function testWalletCreation() public {
        address[] memory owners = new address[](3);
        owners[0] = address(1);
        owners[1] = address(2);
        owners[2] = address(3);
        uint256 threshold = 2;
        string memory title = "My Wallet";
        bool autoExecute = false;
        vm.prank(address(1));
        address walletAddress = factory.createNewMultiSigWallet(
            title,
            owners,
            threshold,
            autoExecute
        );
        console.log(walletAddress);
        vm.prank(address(1));
        assertEq(
            walletAddress,
            factory.fetchWallets(address(1))[0].walletAddress
        );
    }
}
