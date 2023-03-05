// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WETH.sol";

contract WETHTest is Test {
    WETH9 private weth;

    receive() external payable {}
    
    function setUp() public {
        weth = new WETH9();
    }

    function testDesposit(uint96 amount) public {
        (bool sent, ) = address(weth).call{value: amount, gas: 1 ether}("");
        require(sent, "Send ETH");
        assertEq(weth.balanceOf(address(this)), amount);
        weth.withdraw(amount);
        assertEq(weth.balanceOf(address(this)), 0);
    }
}
