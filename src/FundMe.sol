// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    address public immutable OWNER;
    uint256 public constant MINIMUM_USD = 5 * 1e18;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        OWNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        // allow users to send $
        // Have a minimum $ send
        // 1.How do we send ETH to this contract
        require(
            msg.value.getConversionRate(AggregatorV3Interface(s_priceFeed)) >=
                MINIMUM_USD,
            "you didn't send enought ether!"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address addressFunder = s_funders[funderIndex];
            s_addressToAmountFunded[addressFunder] = 0;
            // reset array
            // withdraw the funds
        }
        s_funders = new address[](0);

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

    function getVersion() public view returns (uint256) {
        return PriceConverter.getversion(s_priceFeed);
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

    // function getVersion() public view returns (uint256) {
    //     return PriceConverter.getversion();
    // }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }
}
