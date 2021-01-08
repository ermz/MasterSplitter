pragma solidity 0.7.4;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Pausable is Ownable {
	
	bool public isPaused;

	constructor () {
		isPaused;
	}

	//Does this work better, I'm using your example from a question you answered on stack exchange
    modifier onlyIfRunning public {
        require(!isPaused, "Contract Paused");
        _;
    }

    // Having one function that toggles isPaused "on" and "off" is better than having two separate functions
    function contractSwitch() public onlyOwner {
        if(isPaused) {
        	isPaused = false;
        } else {
        	isPaused = true;
        }
    }


}