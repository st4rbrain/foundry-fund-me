// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol"; 
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumUSDIsFive() public {
        assertEq(fundMe.getMinimumUSD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

}