// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";


contract InteractionsTest is Test {

    FundMe fundMe;

    uint256 constant SEND_VALUE = 0.1 ether;
    address private USER = makeAddr("user");
    uint256 constant startingUserBalance = 1 ether;

    modifier funded() {
        hoax(USER, startingUserBalance);    // Next transaction will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testUserCanFundThroughFundFundMe() external {
        uint256 startingFundMeBalance = address(fundMe).balance;

        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe{value: SEND_VALUE}(address(fundMe));

        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, startingFundMeBalance+SEND_VALUE);
    }

    function testOwnerCanWithdrawThroughWithdrawFundMe() external funded {
        // Assign
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        // Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance+startingFundMeBalance);
    }

}