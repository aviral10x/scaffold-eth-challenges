// SPDX-License-Identifier: MIT
pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    uint256 public constant tokensPerEth = 100;

    function buyTokens() public payable {
        uint256 amountOfTokens = msg.value * tokensPerEth;

        require(
            yourToken.balanceOf(address(this)) >= amountOfTokens,
            "Not enough tokens in the reserve"
        );

        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;

        payable(msg.sender).transfer(balance);
    }

    // ToDo: create a sellTokens(uint256 _amount) function:

    function sellTokens(uint256 _amount) public {
        uint256 amountOfETH = _amount / tokensPerEth;
        require(
            address(this).balance >= amountOfETH,
            "Not enough ETH in the reserve"
        );
        yourToken.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(amountOfETH);
        emit BuyTokens(msg.sender, amountOfETH, _amount);
    }
}