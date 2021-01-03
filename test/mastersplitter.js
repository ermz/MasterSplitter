const MasterSplitter = artifacts.require("MasterSplitter");

contract('MasterSplitter', () => {
	it('should deploy MasterSplitter smart contract properly', async () => {
		const masterSplitter = await MasterSplitter.deployed();
		assert(masterSplitter.address !== '')
	})
})