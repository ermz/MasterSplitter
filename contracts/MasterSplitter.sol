pragma solidity 0.7.4;

import "./Pausable.sol";

contract MasterSplitter is Pausable {
    
    address payable public owner;
    event MoneyIn(address sender, address payeeOne, address payeeTwo, uint amount);
    event MoneyOut(address payee, uint amount);
    
    //I'm using owner address to create a kill switch at the bottom
    constructor () {
        owner = msg.sender;
    }
    
    //Modifier used for the kill switch, so only the owner has access
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
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
        if (remainder != 0) {
            msg.sender.transfer(remainder);
        }
    }
    
    // By having a separated withdraw function, there's no need for onlyOwner modifier (since only those with the etherOwed mapping will get payed)
    function withdraw() public onlyIfRunning {
        emit MoneyOut(msg.sender, etherOwed[msg.sender]);
        etherOwed[msg.sender] = 0;
        msg.sender.transfer(etherOwed[msg.sender]);   
    }
    
    
}