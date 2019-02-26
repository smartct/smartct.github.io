pragma solidity ^0.4.24;

contract work_overtime{

    uint startTimeStamp;
    uint endTimeStamp;
    
    mapping (address => uint256) public balances;
    
    function deposit() public payable returns(bool success) {
        balances[msg.sender] +=msg.value;
        return true;
    }
    function withdrawEth(uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        msg.sender.transfer(valueWei);
        return true;
    }
    function requestPayment(address to) public returns(bool success){
        require(startTimeStamp!=0 && endTimeStamp != 0);
        transferEth(to, 1);
        success = true;
    }
    function transferEth(address to, uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        to.transfer(valueWei);
        return true;
    }
/*
    function showBalanceEth() public view returns(uint256){
        return balances[msg.sender] / (10**18);
    }
*/

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