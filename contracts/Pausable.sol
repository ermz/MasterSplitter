pragma solidity 0.7.4;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Pausable is Ownable {
	bool public isPaused;

	constructor () {
		isPaused;
	}

	modifier onlyIfRunning public {
		require(!isPaused, "Contract Paused");
		_;
	}

	function contractSwitch() public onlyOwner {
		if (isPaused) {
			isPaused = false;
		} else {
			isPaused = true;
		}
	}
}