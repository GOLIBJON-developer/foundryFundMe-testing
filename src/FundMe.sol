// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5 * 1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;
    address public immutable OWNER;

    constructor() {
        OWNER = msg.sender;
    }

    function fund() public payable {
        // allow users to send $
        // Have a minimum $ send
        // 1.How do we send ETH to this contract
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "you didn't send enought ether!"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address addressFunder = funders[funderIndex];
            addressToAmountFunded[addressFunder] = 0;
            // reset array
            // withdraw the funds
        }
        funders = new address[](0);

        // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Transaction failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Transaction Failed");
    }

    // require(msg.sender==owner,"You're not the owner!");
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != OWNER) revert NotOwner();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
