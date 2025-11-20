// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract CounterScript is Script {
    FundMe public fundMe;

    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        fundMe = new FundMe();

        vm.stopBroadcast();
    }
}
