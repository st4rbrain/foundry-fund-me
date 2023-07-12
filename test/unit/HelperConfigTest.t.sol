// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; 
import {HelperConfig} from "script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    HelperConfig helperConfig;

    function setUp() external {
        helperConfig = new HelperConfig();
    }

    function testNetworkConfigPriceFeedAddressAreAccurate() external {
        assertEq(helperConfig.getSepoliaEthConfig().priceFeed, 0x694AA1769357215DE4FAC081bf1f309aDC325306);
        assertEq(helperConfig.getMainnetEthConfig().priceFeed, 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); 
        assertEq(helperConfig.getPolygonMumbaiConfig().priceFeed, 0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada); 
    }

}