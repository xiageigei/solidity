// SPDX-License-Identifier: MIT
pragma solidity ~0.8;

contract Voting{
    mapping(address addr =>mapping(string name => uint256 amount)) public  maMapping;
    mapping(address => string[]) public userNames;
    mapping(address => mapping(string => bool)) public nameExists; // 记录 name 是否已存在
   
    // 允许用户投票给某人
    function setVote(string memory name) public{
        uint256 nums =  maMapping[msg.sender][name];
        maMapping[msg.sender][name] = nums +1;
        
        if(!nameExists[msg.sender][name]){
            userNames[msg.sender].push(name);
            nameExists[msg.sender][name] = true;
        }
    }

    // 获取某个候选人的得票数
    function getVotes(string memory name) public view returns(uint256 amount){
        return (maMapping[msg.sender][name]);
    }

    // 重置所有候选人的得票数
    function resetVotes() public{
        for (uint i = 0; i < userNames[msg.sender].length; i++) {
            string memory name = userNames[msg.sender][i];
            delete maMapping[msg.sender][name];
        }
        delete userNames[msg.sender];
    }
}