// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 constant MINIMUM_USD = 5e18;

    address[] private funders;
    mapping (address funder => uint256 amountFunded) private addressToAmountFunded;

    function fundMe() external payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Send at least $5");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external {

    }

}