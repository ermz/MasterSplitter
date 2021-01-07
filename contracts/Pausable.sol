pragma solidity >=0.6.0 < 0.7.5;

import "../node_modules/contracts/access/Ownable.sol";

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

    //Removed selfdestruct function and will now use a boolean instead
    //I kept the onlyOwner modifier to avoid other stopping the split function
    function stopContract() public onlyOwner {
        isPaused = true;
    }

}