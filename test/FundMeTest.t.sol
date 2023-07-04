// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol"; 
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{

    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumUSDIsFive() public {
        assertEq(fundMe.getMinimumUSD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), address(this));
    }

}