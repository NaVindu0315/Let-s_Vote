//SPDX-License-Identifier: MIT
//tp dp :
//pragma solidity ^0.8.22;

contract Twitter {


    //CODE
    mapping (address => string ) public tweets;
    
        function createTweet(string memory _tweet) public {
            tweets[msg.sender] =_tweet;
        }


        function getTweet(address _owner) public view returns (string memory){
            return tweets[_owner];

        }
        
    



}