// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    uint256 public deadline = block.timestamp + 72 hours;
    uint256 public constant threshold = 1 ether;
    bool openForWithdraw = false;
    mapping(address => uint256) public balances;
    event Stake(address, uint256);
    ExampleExternalContract public exampleExternalContract;

    modifier notCompleted() {
        require(!exampleExternalContract.completed(), "Staking Time is over");
        _;
    }

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    receive() external payable {
        stake();
    }

    function stake() public payable {
        require(msg.value > 0, "Staking amount cannot be zero!");
        require(
            block.timestamp <= deadline,
            "You cannot stake after the deadline is passed"
        );
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function execute() public notCompleted {
        require(block.timestamp >= deadline, "Deadline is not over yet!");
        if (address(this).balance < threshold) {
            openForWithdraw = true;
        } else {
            exampleExternalContract.complete{value: address(this).balance}();
        }
    }

    function withdraw() public notCompleted {
        require(openForWithdraw == true, "you can't withdraw yet!");
        require(
            address(this).balance < threshold && block.timestamp >= deadline,
            "you can't withdraw yet!"
        );
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        } else {
            return deadline - block.timestamp;
        }
    }
}