pragma solidity >=0.6.0 < 0.7.5;

contract MasterSplitter {
    
    address payable public owner;
    bool public isPaused = false;
    
    //I'm using owner address to create a kill switch at the bottom
    constructor () {
        owner = msg.sender;
    }
    
    //Does this work better, I'm using your example from a question you answered on stack exchange
    modifier onlyIfRunning {
        require(isPaused == false);
        _;
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
    
    uint amountSplit;
    uint splitRemainder;
    
    // The if statement will return the remainder to the sender, if there's any
    function split(address payable payeeOne, address payable payeeTwo) external someoneElse(payeeOne, payeeTwo) onlyIfRunning validAddresses(payeeOne, payeeTwo) payable {
        amountSplit = msg.value / 2;
        splitRemainder = msg.value % 2;
        payeeOne.transfer(amountSplit);
        payeeTwo.transfer(amountSplit);
        if (splitRemainder != 0) {
            msg.sender.transfer(splitRemainder);
        }
    }
    
    //Removed selfdestruct function and will now use a boolean instead
    //I kept the onlyOwner modifier to avoid other stopping the split function
    function stopContract() public onlyOwner {
        isPaused = true;
    }
    
    
}