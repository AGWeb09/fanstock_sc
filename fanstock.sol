// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract FanStock{

    /*
    * New action has been created by platform
    */ 
    event newActionCreated(uint id);
    /*
    * New action has been payed by the creator
    */
    event newActionPayed(uint id, address addressPayer);

    struct Action{
        uint payedAmount;
        address addressPayer;
        uint price;
    }
    
    address private platform;
    mapping (uint => Action) actions;

    modifier onlyPlatform(){
        require(msg.sender == platform, "Only ME can do this.");
        _;
    }
    
    constructor(){
        platform = msg.sender;
    }

    /*
    * Create an Action, only for Platform
    */
    function createAction(uint _idAction, uint price) public onlyPlatform {
        require(price > 0, "Set a price!");
        actions[_idAction].price = price;
        actions[_idAction].payedAmount = 0;
        emit newActionCreated(_idAction);
    }

    /*
    * Pay the Action, got the Action!
    */
    function buildAction(uint _idAction) public payable {
        require(msg.value >= 0, "Price to low!");
        actions[_idAction].addressPayer = msg.sender;
        actions[_idAction].payedAmount += msg.value;
        payable(platform).transfer(msg.value);
        emit newActionPayed(_idAction, msg.sender);
    }

    /*
    * Check if the Action has been payed.
    */
    function getActionIsPayed(uint _idAction) external view returns(uint amount) {
        if(actions[_idAction].payedAmount > 0){
            return actions[_idAction].payedAmount;
        } else {
            return 0;
        }
    }
    
}
