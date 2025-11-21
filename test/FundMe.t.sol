// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract CounterTest is Test {
    FundMe public fundMe;

    function setUp() public {
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testMinimumFiveDollar() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsOwner() public view {
        // console.log(address(this));
        // console.log(fundMe.OWNER());
        // console.log(msg.sender); /* this is not the same with  owner of the contract */
        //  us -> FundMeTest -> FundMe
        assertEq(address(this), fundMe.OWNER());
    }

    function testVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }
}
