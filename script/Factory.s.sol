//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Factory} from "../src/Factory.sol";

contract DeployFactory is Script {
    function run() public {
        vm.startBroadcast();
        Factory factory = new Factory();
        vm.stopBroadcast();
    }
}