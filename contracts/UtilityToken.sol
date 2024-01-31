// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UtilityToken is ERC20, Ownable {
    uint256 private _totalSupply;
    uint256 private MAXSUP;
    uint256 constant MAXIMUMSUPPLY = 1000000 * 10 ** 18;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function maxSupply() public pure returns (uint256) {
        return MAXIMUMSUPPLY;
    }
}
