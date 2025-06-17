// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../Interfaces/IStrategy.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract HighRiskStrategy is IStrategy, Ownable {

    address immutable public USDC;
    address public activePool; // e.g., AaveStrategy contract

    event ActivePoolUpdated(address indexed newPool);

    constructor(address _usdc) {
        USDC = _usdc;
    }

    function setActivePool(address _newPool) external onlyOwner {
        require(_newPool != address(0), "Invalid address");
        activePool = _newPool;
        emit ActivePoolUpdated(_newPool);
    }

    function execute(address user, uint256 amount) external override {
    require(activePool != address(0), "No active pool set");

    IERC20(USDC).transferFrom(user, address(this), amount);
    IERC20(USDC).approve(activePool, amount);

    IStrategy(activePool).execute(user, amount);
}
}
