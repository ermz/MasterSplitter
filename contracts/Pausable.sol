pragma solidity 0.7.4;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Pausable is Ownable {
	bool public isPaused;

	event ToggleSwitch(bool isPaused);

	constructor () {
		isPaused;
	}

	modifier onlyIfRunning public {
		require(!isPaused, "Contract Paused");
		_;
	}

	modifier onlyIfPaused public {
		require(isPaused, "Contract Running");
	}

	function runSwitch(bool onOff) public onlyOwner {
		isPaused = onOff;
		emit ToggleSwitch(onOff);
	}
}