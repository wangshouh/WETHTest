// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

contract Overflow {
    uint public x;
    uint public y;

    constructor(uint x_, uint y_) {
        (x, y) = (x_, y_);
    }

    function add(uint x_, uint y_) public pure returns (uint) {
        return x_ + y_;
    }

    function divide(uint x_, uint y_) public pure returns (uint) {
        return x_ / y_;
    }
}