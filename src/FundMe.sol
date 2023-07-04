// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// custom error to check owner
error FundMe__NotOwner();

contract FundMe {
    // price converter library functions applicable for all uint256 data type variables
    using PriceConverter for uint256;

    uint256 constant MINIMUM_USD = 5e18;
    address private immutable i_owner;

    address[] private funders;
    mapping (address funder => uint256 amountFunded) private addressToAmountFunded;
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }
    

    constructor(address priceFeed) {
        // set the contract deployer as the owner
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // Handle ETH sent directly without using the fund funciton
    receive() external payable {
        fundMe();
    }

    fallback() external payable {
        fundMe();
    }


    function fundMe() public payable {
        // Checking for a minimum amount of 5 USD
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Send at least $5");

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


    // getter functions
    function getAddressToAmountFunded(address funder) external view returns(uint256) {
        return addressToAmountFunded[funder];
    }

    function getFunder(uint256 index) external view returns(address) {
        return funders[index];
    }

    function getOwner() external view returns(address) {
        return i_owner;
    }

    function getMinimumUSD() external pure returns(uint256) {
        return MINIMUM_USD;
    }

    function getVersion() external view returns(uint256){
        return s_priceFeed.version();
    }

}