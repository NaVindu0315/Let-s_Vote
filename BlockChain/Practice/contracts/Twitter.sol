//SPDX-License-Identifier: MIT
//tp dp :
pragma solidity ^0.8.22;

contract Twitter {

    uint16 constant MAX_TWEET_Length = 280;

    ///struct for the tweets
    struct Tweet{
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    ///end struct


    //CODE
    mapping (address => Tweet[] ) public tweets;


    
        function createTweet(string memory _tweet) public {
                ///  condintional 
                /// legth <=280
                require(bytes(_tweet).length<=MAX_TWEET_Length,"Tweet is too Long");

            Tweet memory newTweet = Tweet({
                author : msg.sender,
                content : _tweet,
                timestamp : block.timestamp,
                likes : 0

            });


            tweets[msg.sender].push(newTweet);
        }
        //to store tweets in array 
        //.push(_tweeet) added
        //uint i added in get tweet function

    //to get the specific tweet
        function getTweet(uint _i) public view returns (Tweet memory){
            return tweets[msg.sender][_i];

        }
        
        //to get all the tweets
        function getalltweets(address _owner) public view returns (Tweet[] memory)
        {
            return tweets[_owner];
        }    



}

