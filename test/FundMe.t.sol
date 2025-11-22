// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {CounterScript} from "../script/FundMe.s.sol";

contract CounterTest is Test {
    FundMe public fundMe;

    function setUp() public {
        CounterScript deployScript = new CounterScript();
        fundMe = deployScript.run();
    }

    function testMinimumFiveDollar() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsOwner() public view {
        // console.log(address(this));
        // console.log(fundMe.OWNER());
        // console.log(msg.sender); /* this is not the same with  owner of the contract */
        //  us -> FundMeTest -> FundMe
        assertEq(msg.sender, fundMe.OWNER());
    }

    function testVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }
}
