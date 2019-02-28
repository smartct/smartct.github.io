pragma solidity ^0.4.24;

contract work_overtime{

    uint startTimeStamp;
    uint endTimeStamp;
    bool paid;
    
    mapping (address => uint256) public balances;
    
    constructor () public{
        paid = false;
    }
    
    event CurrentBalance(uint balance);
    
    function deposit() public payable returns(bool success) {
        balances[msg.sender] +=msg.value;
        emit CurrentBalance(balances[msg.sender]);
        return true;
    }
    
    function withdrawEth(uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        msg.sender.transfer(valueWei);
        emit CurrentBalance(balances[msg.sender]);
        return true;
    }
    
    function requestPayment(address to) public returns(bool success){
        require(startTimeStamp!=0 && endTimeStamp != 0 && paid != true);
        transferEth(to, 1);
        success = true;
        paid = true;
    }
    
    function transferEth(address to, uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        to.transfer(valueWei);
        emit CurrentBalance(balances[msg.sender]);
        return true;
    }

    function setStartTime() public{
        // startTime can be initialized only once
        require( startTimeStamp == 0);
        startTimeStamp = now;
    }
    
    function setEndTime() public{
        // endTime can be initialized whenever you want
        require (startTimeStamp != 0);
        endTimeStamp = now;
    }
    
    function initTime() public{
        startTimeStamp = 0;
        endTimeStamp = 0;
        paid = false;
    }

    function getStartTime() public view returns (uint timeStamp){
        require(startTimeStamp > 0);
        timeStamp = startTimeStamp;
    }
    
    function getEndTime() public view returns (uint timeStamp){
        require(endTimeStamp > 0);
        timeStamp = endTimeStamp;
    }
    
}