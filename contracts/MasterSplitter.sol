pragma solidity >=0.6.0 < 0.7.5;

contract MasterSplitter {
    
    address payable public owner;
    bool public isPaused;
    event MoneyIn(address sender, address payeeOne, address payeeTwo, uint amount);
    event MoneyOut(address payee, uint amount);
    
    //I'm using owner address to create a kill switch at the bottom
    constructor () {
        owner = msg.sender;
        isPaused = false;
    }
    
    //Does this work better, I'm using your example from a question you answered on stack exchange
    modifier onlyIfRunning {
        require(!isPaused);
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
    mapping (address => uint) etherOwed;
    
    // The if statement will return the remainder to the sender, if there's any
    function split(address payable payeeOne, address payable payeeTwo) external someoneElse(payeeOne, payeeTwo) onlyIfRunning validAddresses(payeeOne, payeeTwo) payable {
        etherOwed[payeeOne] = msg.value / 2;
        etherOwed[payeeTwo] = msg.value / 2;

        if (splitRemainder != 0) {
            msg.sender.transfer(msg.value % 2);
        }
        
        emit MoneyIn(msg.sender, payeeOne, payeeTwo, msg.value);
    }
    
    // By having a separated withdraw function, there's no need for onlyOwner modifier (since only those with the etherOwed mapping will get payed)
    function withdraw() public onlyIfRunning {
        msg.sender.transfer(etherOwed[msg.sender]);
        etherOwed[msg.sender] = 0;
        emit MoneyOut(msg.sender, etherOwed[msg.sender]);
    }
    
    //Removed selfdestruct function and will now use a boolean instead
    //I kept the onlyOwner modifier to avoid other stopping the split function
    function stopContract() public onlyOwner {
        isPaused = true;
    }
    
    
}