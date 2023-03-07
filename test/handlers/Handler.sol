// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {WETH9} from "../../src/WETH.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract Handler is StdCheats {
    WETH9 public weth;

    constructor(WETH9 _weth) {
        weth = _weth;
        deal(address(this), 10 ether);
    }

    function deposit(uint256 amount) public {
        weth.deposit{ value: amount }();
    }
}
