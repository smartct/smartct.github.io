pragma solidity ^0.4.24;

contract work_overtime{

    uint startTimeStamp;
    uint endTimeStamp;
    uint balance;
    bool paid;
    
    mapping (address=>string) name;
    address creator_addr;
    event sendEth(string senderName, uint startTime, uint endTime, uint amount);
    constructor () public{
        creator_addr = msg.sender;
        name[msg.sender] = "tester";
        paid = false;
    }
    
    function deposit() public payable {
        balance += msg.value;
    }
    
    function withdrawEth(uint value) public {
        uint valueWei = value * (10**18);
        require(balance>= valueWei);
        balance -= valueWei;
        msg.sender.transfer(valueWei);
    }

    function setName(string worker_name) public{
        name[msg.sender] = worker_name;
    }
    function startOverTime() public{
        initTime();
        setStartTime();
        paid = false;
    }
    
    function initTime() public{
        startTimeStamp = 0;
        endTimeStamp = 0;
    }
    
    function setStartTime() public{
        // startTime can be initialized only once
        require( startTimeStamp == 0);
        startTimeStamp = now;
    }
    
    function finishOverTime() public{
        require (paid != true && balance >= 10**18 );
        setEndTime();
        requestPayment();
        paid = true;
    }

    function setEndTime() public{
        require (startTimeStamp != 0);
        endTimeStamp = now;
    }
    
    function requestPayment() public {
        require(startTimeStamp!=0 && endTimeStamp != 0);
        
        uint valueWei = 1 * (10**18);
        require(balance >= valueWei);
        balance -= valueWei;
        msg.sender.transfer(valueWei);
        
        emit sendEth(name[msg.sender], startTimeStamp, endTimeStamp, 1);
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