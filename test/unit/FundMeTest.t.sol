// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol"; 
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 private constant SEND_VALUE = 0.1 ether;
    uint256 private constant STARTING_BALANCE = 10 ether;

    event Funded(address indexed funder, uint256 indexed amount);

    modifier funded() {
        vm.prank(USER);     // Next transaction will be sent by USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
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

    function testFundFailsWithoutMinimumUSD() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function fallbackExecutesOnDirectTransfer() public {
        (bool success, ) = address(payable(fundMe)).call{value: SEND_VALUE}("0x12");
        assert(success);
    }

    function testFundUpdatesAddressToAmountFunded() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testFundAddsFunderToArrayOfFundersIfNew() public funded funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
        assertEq(fundMe.getNumberOfFunders(), 1);
    }
    
    function testMaximumAmountFundedGetsUpdated() external funded {
        assert(fundMe.getMaximumAmountFunded() == SEND_VALUE);
    }

    function testLatestAmountFundedUpdatesOnFund() external funded {
        assert(fundMe.getLatestAmountFunded() == SEND_VALUE);
    }

    function testFundEmitsFundedEvent() external {
        vm.prank(USER);
        vm.expectEmit(true, false, false, false, address(fundMe));

        emit Funded(USER, SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testResetAllData() external funded {
        vm.prank(msg.sender);
        fundMe.resetAllData();
        assert(fundMe.getNumberOfFunders() == 0);
        assert(fundMe.getTotalAmountFunded() == 0);
        assert(fundMe.getAddressToAmountFunded(USER) == 0);
    }

}