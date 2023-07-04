// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {
    // price converter library functions applicable for all uint256 data type variables
    using PriceConverter for uint256;

    uint256 constant MINIMUM_USD = 5e18;

    address[] private funders;
    mapping (address funder => uint256 amountFunded) private addressToAmountFunded;

    address immutable i_owner;

    constructor() {
        // set the contract deployer as the owner
        i_owner = msg.sender;
    }

    function fundMe() external payable {
        // Checking for a minimum amount of 5 USD
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Send at least $5");

        // update the funders array
        funders.push(msg.sender);
        // update the mapping of address to amounts
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external onlyOwner {
        uint256 totalFunders = funders.length;

        // reset the funded amounts to zero
        for (uint256 funderIndex=0; funderIndex<totalFunders; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // resetting the funders array
        funders = new address[](0);

        // Send the contract balance to the owner
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Call failed");
    }

    modifier onlyOwner {
        require(msg.sender == i_owner, "Not owner");
        _;
    }

}