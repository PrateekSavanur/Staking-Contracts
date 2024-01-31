// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract StableToken is ERC20, ERC20Burnable, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => bool) controllers;

    uint256 private _totalSupply;
    uint256 private MAXSUP;
    uint256 constant MAXIMUMSUPPLY = 1000000 * 10 ** 18;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) external {
        require(controllers[msg.sender], "Only controllers can mint");
        require((MAXSUP + amount) <= MAXIMUMSUPPLY, "Maximum supply has been reached");
        _totalSupply = _totalSupply + amount;
        MAXSUP = MAXSUP + amount;
        _balances[to] = _balances[to] + amount;
        _mint(to, amount);
    }

    function burnFrom(address account, uint256 amount) public override {
        if (controllers[msg.sender]) {
            _burn(account, amount);
        } else {
            super.burnFrom(account, amount);
        }
    }

    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
    }

    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function maxSupply() public pure returns (uint256) {
        return MAXIMUMSUPPLY;
    }
}
