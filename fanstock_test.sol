// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "hardhat/console.sol";

import "../contracts/FanStock.sol";

contract FanStockTest {
   
    address acc0;
    address acc1;
    address acc2;
    
    FanStock contractToTest;
    
    function beforeAll () public {
        contractToTest = new FanStock();
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
        Assert.equal(msg.sender, acc0, "Account 0 isn't operating");

    }
    
    /// #sender: account-0
    function createActions() public {
        Assert.equal(msg.sender, acc0, "First Account is creating");
        contractToTest.createAction(8,1000000000000000);
    }


    /// #sender: account-1
    /// #value: 1000000000000000
    function payForAction() payable public{
        console.log(msg.value);
        Assert.ok(msg.value == 1000000000000000, "Message Value is not 100");
        contractToTest.buildAction{value: msg.value}(8);
    }

    /// #sender: account-2
    function getActionIsPayed() public{
        uint amount = contractToTest.getActionIsPayed(8);
        Assert.equal(amount, 1000000000000000, "Amount is wrong");
    }
    
}


