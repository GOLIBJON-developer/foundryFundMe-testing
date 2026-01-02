// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {CounterScript} from "../../script/FundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe public fundMe;

    address USER = makeAddr("user"); //create Fake user testing purposes only
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        CounterScript counterScript = new CounterScript();
        fundMe = counterScript.run();
        vm.deal(USER, STARTING_BALANCE); // adding balance
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFunMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFunMe(address(fundMe));

        // address funder = fundMe.getFunder(0);
        assert(address(fundMe).balance == 0);
    }
}
