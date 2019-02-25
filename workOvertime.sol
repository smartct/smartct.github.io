pragma solidity ^0.4.24;

import "./BokkyPooBahsDateTimeLibrary.sol";
contract work_overtime{
    using BokkyPooBahsDateTimeLibrary for uint;
    struct Time{
        uint hour;
        uint min;
        uint sec;
    }
    Time minimumWorkingTime;
    Time startTime;
    Time endTime;
    
    uint startTimeStamp;
    uint endTimeStamp;
    
    mapping (address => uint256) public balances;

    constructor () public
    {
        startTimeStamp = 0;
        endTimeStamp   = 0;
        minimumWorkingTime.hour = 0;
        minimumWorkingTime.min  = 0;
        minimumWorkingTime.sec  = 30;
    }
    function deposit() public payable returns(bool success) {
        balances[msg.sender] +=msg.value;
        return true;
    }
    
    function showBalanceEth() public view returns(uint256){
        return balances[msg.sender] / (10**18);
    }
    function withdrawEth(uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        msg.sender.transfer(valueWei);
        return true;
    }

    function transferEth(address to, uint value) public returns(bool success) {
        uint valueWei = value * (10**18);
        require(balances[msg.sender] >= valueWei);
        balances[msg.sender] -= valueWei;
        to.transfer(valueWei);
        return true;
    }
    function setMinimumWorkingTime(uint _hour, uint _min, uint _sec) public{
        minimumWorkingTime.hour = _hour;
        minimumWorkingTime.min  = _min;
        minimumWorkingTime.sec  = _sec;
    }
    
    function setStartTime() public{
        // startTime can be initialized only once
        if(startTimeStamp == 0 )
            startTimeStamp = now;
        
        (,,,startTime.hour,startTime.min,startTime.sec) =
            BokkyPooBahsDateTimeLibrary.timestampToDateTime(startTimeStamp);
            
        startTime.hour += 9;
    }
    function setEndTime() public{
        require (startTimeStamp != 0);
        // endTime can be initialized whenever you want
        endTimeStamp = now;
        (,,,endTime.hour,endTime.min,endTime.sec) =
            BokkyPooBahsDateTimeLibrary.timestampToDateTime(endTimeStamp);
            
        endTime.hour += 9;
    }
    function requestPayment(address to) public returns(bool success){
        require(startTimeStamp!=0 && endTimeStamp > startTimeStamp);
        uint totalSeconds = minimumWorkingTime.hour * 3600 
                            + minimumWorkingTime.min * 60    
                            +  minimumWorkingTime.sec;
        if(totalSeconds <= BokkyPooBahsDateTimeLibrary.diffSeconds(startTimeStamp, endTimeStamp)){
          transferEth(to, 1);
          success = true;
        }
    }
    function getTimeDiff() view public returns(uint hour, uint min, uint sec, bool success){
        require (startTimeStamp > 0 && endTimeStamp >= startTimeStamp);
        hour = BokkyPooBahsDateTimeLibrary.diffHours(startTimeStamp, endTimeStamp);
        min  = BokkyPooBahsDateTimeLibrary.diffMinutes(startTimeStamp, endTimeStamp);
        sec  = BokkyPooBahsDateTimeLibrary.diffSeconds(startTimeStamp, endTimeStamp);
        success = true;
    }

    function getStartTime() public view returns (uint hour, uint min, uint sec, bool success){
        require(startTimeStamp > 0);
        (hour, min, sec) = (startTime.hour , startTime.min, startTime.sec);
        success = true;
    }
    function getEndTime() public view returns (uint hour, uint min, uint sec, bool success){
        require(endTimeStamp > 0);
        (hour, min, sec) = (endTime.hour , endTime.min, endTime.sec);
        success = true;
    }
    function getMinimumWorkingTime() public view returns (uint hour, uint min, uint sec){
        (hour, min , sec) = 
            (minimumWorkingTime.hour, minimumWorkingTime.min, minimumWorkingTime.sec);
    }
    
}