// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract WBTC is ERC20 {
    constructor() ERC20("Team701 WBTC", "WBTC") {
        _mint(msg.sender, 1_000_000_000 * 1e18);
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }
}
