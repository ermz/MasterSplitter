pragma solidity 0.7.4;

import "./Pausable.sol";

contract MasterSplitter is Pausable {
    
    event MoneyIn(address indexed sender, address indexed payeeOne, address indexed payeeTwo, uint amount);
    event MoneyOut(address indexed payee, uint amount);
    
    modifier someoneElse(address payeeOne, address payeeTwo) {
        require(msg.sender != payeeOne || msg.sender != payeeTwo);
        _;
    }
    
    //This modifier is to check for empty/invalid addresses, though it might be unnecessary
    //How would I go about checking for empty addresses, or should I just write a test for that 
    modifier validAddresses(address payeeOne, address payeeTwo) {
        require(payeeOne == address(payeeOne) && payeeTwo == address(payeeTwo), "Atleast one address is invalid!");
        _;
    }
    
    mapping (address => uint) public etherOwed;
    
    // The if statement will return the remainder to the sender, if there's any
    function split(address payable payeeOne, address payable payeeTwo) external someoneElse(payeeOne, payeeTwo) onlyIfRunning validAddresses(payeeOne, payeeTwo) payable {
        uint half = msg.value / 2;
        etherOwed[payeeOne] = half;
        etherOwed[payeeTwo] = half;

        emit MoneyIn(msg.sender, payeeOne, payeeTwo, msg.value);

        uint remainder = msg.value % 2;
        if (remainder != 0) msg.sender.transfer(remainder);
    }
    
    // By having a separated withdraw function, there's no need for onlyOwner modifier (since only those with the etherOwed mapping will get payed)
    function withdraw() public onlyIfRunning {
        uint memory withdrawlAmount = etherOwed[msg.sender];
        emit MoneyOut(msg.sender, withdrawlAmount);
        etherOwed[msg.sender] = 0;
        msg.sender.transfer(etherOwed[msg.sender]);   
    }
    
    
}