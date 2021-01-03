pragma solidity >=0.6.0 < 0.7.5;

contract MasterSplitter {
    
    address payable public owner;
    
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
    modifier validAddresses(address payeeOne, address payeeTwo) {
        require(payeeOne == address(payeeOne) && payeeTwo == address(payeeTwo), "Atleast one address is invalid!");
        _;
    }
    
    // I made this public to get rid of the showMeTheMoney function I had previously
    // The comment you left "The contract logic is indifferent to the name and we are using user address as a proxy for an id" really helped organize my thoughts
    mapping (address => uint) public people;
    
    uint amountSplit;
    uint splitRemainder;
    
    // The if statement takes care of the supposed remainder of msg.value/2. I'm just awarding it to the first account
    // I was thinking of transfering the splitRemainder after the fact, but sending an additional tranfer request seemed like it would cost additional gas
    // If I'm understanding correctly I could also use .call, but it wouldn't make sense if it's not for a complex transfer that might need more gas?
    function split(address payable payeeOne, address payable payeeTwo) external someoneElse(payeeOne, payeeTwo) validAddresses(payeeOne, payeeTwo) payable {
        amountSplit = msg.value / 2;
        splitRemainder = msg.value % 2;
        if (splitRemainder > 0) {
            payeeOne.transfer(amountSplit + splitRemainder);
        } else {
            payeeOne.transfer(amountSplit);
        }
        payeeTwo.transfer(amountSplit);
        
        people[msg.sender] = address(msg.sender).balance;
        people[payeeOne] = address(payeeOne).balance;
        people[payeeTwo] = address(payeeTwo).balance;
    }
    
    function killSwitch() public onlyOwner{
        selfdestruct(owner);
    }
    
}