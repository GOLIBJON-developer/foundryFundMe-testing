// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract CounterTest is Test {
    FundMe public fundMe;
    uint256 number = 1;

    function setUp() public {
        fundMe = new FundMe();
    }

    // function test_Increment() public {
    //     fundMe.increment();
    //     assertEq(fundMe.number(), 1);
    // }

    function testMinimumFiveDollar() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
}
