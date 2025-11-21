// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    // using PriceConverter for uint256;
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
            getConversionRate(msg.value) >= MINIMUM_USD,
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

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43     ETH/USD 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // casting to uint256 is safe because chainlink price feed returns positive int256 with 8 decimals
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(answer) * 1e10;
    }

    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getversion() public view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
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
}
