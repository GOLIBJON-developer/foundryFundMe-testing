// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
// import {PriceConverter} from "./Priceconverter.sol";

import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
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

    function getversion() internal view returns (uint256) {
        return
            AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
                .version();
    }
}
