// SPDX-License-Identifier: MIT

pragma solidity 0.8.4; 

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// learn more: https://docs.openzeppelin.com/contracts/4.x/erc20

contract YourToken is ERC20 {
    constructor() ERC20("ETHIndia", "EIF") {
        _mint( msg.sender , 1000 * 10 ** 18);
    }
}