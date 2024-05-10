//SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

contract letsvote3{

    uint candidate_1 = 0;
    uint candidate_2 = 0;
    uint candidate_3 = 0;
    uint candidate_4 = 0;
    uint candidate_5 = 0;

    function vote_1() public{
        candidate_1++;
    }

    function vote_2() public {
        candidate_2++;
    }

    function vote_3() public {
        candidate_3++;
    }

    function vote_4() public {
        candidate_4++;
    }

    function vote_5() public {
        candidate_5++;
    }

    function get_1()public view returns(uint) {
        return  candidate_1;
    }

    function get_2()public view returns(uint) {
        return  candidate_2;
    }

    function get_3()public view returns(uint) {
        return  candidate_3;
    }

    function get_4()public view returns(uint) {
        return  candidate_4;
    }

    function get_5()public view returns(uint) {
        return  candidate_5;
    }


    function clearall() public{
        candidate_1 = 0;

        candidate_2 = 0;

        candidate_3 = 0;

        candidate_4 = 0;

        candidate_5 = 0;
    }

}
