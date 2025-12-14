// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BeggingContract{
    address public immutable owner;  
    mapping(address => uint256) public donations;

    modifier onlyOwner(){
        require(msg.sender == owner, "Begging not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    event DonationReceived(address indexed donor, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    function donate() external payable {
         require(msg.value > 0, "Begging zero");
         donations[msg.sender] += msg.value;
         emit DonationReceived(msg.sender,msg.value);
    }
    function withdraw() external payable onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Begging no balance");
        emit Withdrawn(owner,balance);

        (bool success, )= owner.call{value: balance}("");
        require(success, "Begging call failed");
    }

    function getDonation(address _donor) external view returns(uint256) {
        return donations[_donor];
    }

    // 查看总余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}