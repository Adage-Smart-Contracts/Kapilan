//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Lottery {
    address public owner;
    address payable[] public players;
    address payable public winner;

    // lottery round count
    uint public round = 1;

    constructor() public {
		// setting the adddress of the person who deploy the contract to the owner
        owner = msg.sender;
    }
	
    // new player can be added by himself/herself
    function enterLottery() public payable {
		// requiremnt for joinning the lottery is 1 ether
        require(msg.value == 1 ether);
		
		// address of the player who entering the lottery
        players.push(payable(msg.sender));
    }

    //  modifier to only changes need to be done by the owner
    modifier onlyOwner {
        require(owner == msg.sender);
        _; // whatever other code is in the function, this modifier applied to, have that run after the require statement
    }

    // generate random number
	function getRandomNumber() public view returns(uint) {
		return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }
	
    // winner can be picked only by the owner 
	function pickWinner() public onlyOwner {
        // winner index based on the random number
		uint index = getRandomNumber() % players.length;
		
		winner = players[index];

        // transfer the balance to winner account
        winner.transfer(address(this).balance);
		
		// lotteryHistory[round] = players[index];
		round++;
		
		// reset the state of the contract
		players = new address payable[](0);
    }

    function getOwner() public view returns(address) {
        return owner;
    }

	function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function getRound() public view returns(uint256) {
        return round;
    }

    function getPlayerCount() public view returns(uint256) {
        return players.length;
    }
	
	function getPlayers() public view returns(address payable[] memory) {
        return players;
        // memory indicates that, this just stored in temporary in-system memory, only for the duration of the function life cycle
    }

    function getWinner() public view returns(address) {
        return winner;
    }
}
