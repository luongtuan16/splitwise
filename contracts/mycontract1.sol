// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract Splitwise1 {
    // DO NOT MODIFY ABOVE THIS
    struct Debt {
        address creditor;
        address debtor;
        uint amount;
        uint createdAt;
    }
    struct User {
        uint totalOwed;
        uint lastActivityAt;
    }
    Debt[] debts;
    mapping(address => User) users;

    constructor() {}

    // function getUsers() public returns (address[] memory) {
    //     return users;
    // }

    function lookup(address debtor, address creditor) public returns (uint) {
        //return users[user].totalOwed;
    }

    function add_IOU(address creditor, uint amount) public {
        
    }

    // ADD YOUR CONTRACT CODE BELOW
}
