// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";
import {FundMe} from "src/FundMe.sol";

contract DeployFundMeTest is Test {

    DeployFundMe deployer;
    FundMe fundMe;
    
    function setUp() external {
        deployer = new DeployFundMe();
    }

    function testRunDeploysFundMeContract() external {
        fundMe = deployer.run();
        assert(address(fundMe) != address(0));
    }
}