// SPDX-License-Identifier: UNLICENSED

// DO NOT MODIFY BELOW THIS
pragma solidity >=0.7.0 <0.9.0;

contract Splitwise {
    // DO NOT MODIFY ABOVE THIS

    // ADD YOUR CONTRACT CODE BELOW
    struct User {
        mapping(address => uint32) debts;
        uint32 totalOwed;
        uint256 lastActive;
        address[] creditors;
    }
    mapping(address => User) public users;
    address[] public userAddresses;

    constructor() {}

    function lookup(
        address debtor,
        address creditor
    ) public view returns (uint32 ret) {
        ret = users[debtor].debts[creditor];
    }

    function add_IOU(
        address creditor,
        uint32 amount,
        address[] memory loop
    ) public {
        require(creditor != msg.sender, "Oweing from yourself is not allowed");
        require(amount > 0, "Amount must be a positive number");
        if (users[msg.sender].lastActive == 0) {
            //first debt of debtor
            userAddresses.push(msg.sender);
            users[msg.sender].lastActive = block.timestamp;
        }
        if (users[creditor].lastActive == 0) {
            //first debt of creditor
            userAddresses.push(creditor);
            users[creditor].lastActive = block.timestamp;
        }
        if (users[msg.sender].debts[creditor] == 0) {
            // first debt from creditor -> new creditor
            users[msg.sender].creditors.push(creditor);
        }
        //update ledger
        users[msg.sender].debts[creditor] += amount;
        users[msg.sender].totalOwed += amount;

        //validate and resolve loop
        if (loop.length > 0) resolveDebtLoop(loop);
    }

    function resolveDebtLoop(address[] memory loop) private {
        //call inside contract only
        uint32 amount = 0; //maximum amount to reduce
        for (uint256 i = 0; i < loop.length - 1; i++) {
            address debtor = loop[i];
            address creditor = loop[i + 1];
            uint32 debt = users[debtor].debts[creditor];
            if (debt == 0) break;
            if (debt < amount || amount == 0) amount = debt;
        }
        uint32 lastDebt = users[loop[loop.length - 1]].debts[loop[0]];
        if (amount > 0 && lastDebt > 0) {
            // valid loop -> reduce debts to resolve loop
            if (lastDebt < amount) amount = lastDebt;
            for (uint256 i = 0; i < loop.length - 1; i++) {
                users[loop[i]].totalOwed -= amount;
                users[loop[i]].debts[loop[i + 1]] -= amount;
            }
            users[loop[loop.length - 1]].totalOwed -= amount;
            users[loop[loop.length - 1]].debts[loop[0]] -= amount;
        }
    }

    function getUsers() public view returns (address[] memory) {
        return userAddresses;
    }

    function getCreditors(
        address debtor
    ) public view returns (address[] memory) {
        return users[debtor].creditors;
    }
}
