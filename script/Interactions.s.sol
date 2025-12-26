// Fund
// Withdraw
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    // constructor() {}

    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFunMe(address mostRecentyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundFunMe(mostRecentDeployed);
    }
}

contract WithdrawFundMe is Script {
    // constructor() {}
    function withdrawFunMe(address mostRecentyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentyDeployed)).withdraw();
        vm.stopBroadcast();
        // console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFunMe(mostRecentDeployed);
    }
}
