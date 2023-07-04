// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";

contract HelperConfig {
    // Use mocks when on a local Anvil chain
    // Use relevant address when on a live network

    // struct to return a whole bunch of stuff like Price Feed address, vrf address, gas price
    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig private activeNetworkConfig;


    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }
    

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns(NetworkConfig memory) {

    }

    // getter functions
    function getActiveNetworkConfig() external view returns(NetworkConfig memory) {
        return activeNetworkConfig;
    }

}