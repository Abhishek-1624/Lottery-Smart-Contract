// SPDX-License-Identifier: GPL-3.0 

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    //We dont know exactly how many people will participate in the lottery so we create a dynamic array
    address payable[] public players;
    address public manager;

    constructor(){
        manager = msg.sender; //We set the manager as the person who deploys the contract
    }

    //Entering the lottery
    //(the contract will receive eth only if function called receive or fallback) 
    receive() external payable{
        require(msg.value == 0.1 ether);//This is to make sure everyone must send only 0.1 ether only
        players.push(payable(msg.sender)); //
    }

    function getBalance() public view returns(uint){
        require(msg.sender == manager);//This is to ensure only manager can see the balance
        return address(this).balance;
    }

    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp , players.length)));
        //This is how generate random numbers in solidity
        /*But we cannot use this in a decentralised lottery system as miner can generate the hash and not
        publish it until he wants the hash he wants to publish and make himself the winner 
        DO NOT USE THIS  */
        //To avoid this we need to connect to the chainlink VRF 
    }

    //Now we create a function to Pick the Winner
    function PickWinner() public{
        require(msg.sender == manager); //We need to make sure only the manager selects the winner
        require(players.length >= 3); //To make sure there are more than 3 players
        uint r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index];

        winner.transfer(getBalance());
        players = new address payable[](0); //This is to reset the lottery and start the next session
    }


    
}
