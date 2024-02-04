//SPDX-License-Identifier: MIT
//tp dp :
pragma solidity ^0.8.22;

contract PausableToken
{
    address public owner;
    bool public paused;
    mapping (address => uint) public balances;

    constructor()
    {
        owner =msg.sender;
        paused = false;
        balances[owner] = 1000;
    }
    
}