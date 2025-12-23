// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {CounterScript} from "../script/FundMe.s.sol";

contract CounterTest is Test {
    FundMe public fundMe;

    address USER = makeAddr("user"); //create Fake user testing purposes only
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() public {
        CounterScript deployScript = new CounterScript();
        fundMe = deployScript.run();
        vm.deal(USER, STARTING_BALANCE); // adding balance
    }

    function testMinimumFiveDollar() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsOwner() public view {
        // console.log(address(this));
        // console.log(fundMe.OWNER());
        // console.log(msg.sender); /* this is not the same with  owner of the contract */
        //  us -> FundMeTest -> FundMe
        assertEq(msg.sender, fundMe.getOwner());
    }

    function testVersionIsAccurate() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // reverts next line code, works like if next line code revert or err this test is true
        fundMe.fund();
    }

    modifier funded() {
        vm.prank(USER); // user came and sending value
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testFundUpdate() public funded {
        // vm.prank(USER); // user came and sending value
        // fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER); //checking the user
        assertEq(amountFunded, SEND_VALUE); // compares balance of money and user sended value
    }

    function testAddressFunderToArrayOfFunders() public funded {
        // vm.prank(USER); // user came and sending value
        // fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        // vm.prank(USER);
        // fundMe.fund{value: SEND_VALUE}();

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // owner has some money
        uint256 startingFundMeBalance = address(fundMe).balance; // contract has some money

        //Acc
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw(); // owner withdraw all money
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance; //now all money in owner balance
        uint256 endingFundMeBalance = address(fundMe).balance; // 0
        assertEq(endingFundMeBalance, 0); // true
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        ); // true
    }

    function testWithdrawFromMultipleFunders() public funded {
        //Arrange
        uint160 numOfFunders = 10; // when working address generating use uint160
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address
            // address()
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // owner has some money
        uint256 startingFundMeBalance = address(fundMe).balance; // contract has some money

        //Acc
        // vm.prank(fundMe.getOwner());
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw(); // owner withdraw all money
        vm.stopPrank();

        //Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            fundMe.getOwner().balance
        ); // true
    }
}
