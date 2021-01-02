pragma solidity >=0.6.0 < 0.7.5;

contract Splitter {
    
    address payable public admin;
    uint escrow;
    
    constructor () payable {
        admin = msg.sender;
        escrow = msg.value;
    }
    
    struct Person {
        address personId;
        string name;
        uint balance;
    }
    
    modifier someoneElse(address payeeOne, address payeeTwo) {
        require(msg.sender != payeeOne || msg.sender != payeeTwo);
        _;
    }
    
    modifier samePerson(address owner) {
        require(msg.sender == owner);
        _;
    }
    
    mapping (address => Person) people;
    
    function createPerson(string memory _name) public payable {
        people[msg.sender] = Person(msg.sender, _name, msg.value);
    } 
    
    uint amountSplit;
    
    function split(address payable payeeOne, address payable payeeTwo) external someoneElse(payeeOne, payeeTwo) payable {
        amountSplit = msg.value / 2;
        payeeOne.transfer(amountSplit);
        payeeTwo.transfer(amountSplit);
        people[payeeOne].balance += amountSplit;
        people[payeeTwo].balance += amountSplit;
    }
    
    function showMeTheMoney(address addrs) public view samePerson(addrs) returns(uint) {
        return people[addrs].balance;
    }
    
    
}