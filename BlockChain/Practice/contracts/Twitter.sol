//SPDX-License-Identifier: MIT
//tp dp :
//pragma solidity ^0.8.22;

contract Twitter {


    //CODE
    mapping (address => string[] ) public tweets;
    
        function createTweet(string memory _tweet) public {
            tweets[msg.sender].push(_tweet);
        }
        //to store tweets in array 
        //.push(_tweeet) added
        //uint i added in get tweet function


        function getTweet(address _owner,uint _i) public view returns (string memory){
            return tweets[_owner][_i];

        }
        
    



}

