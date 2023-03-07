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

    function testDesposit(uint96 amount, uint96 preBalance, uint96 preETHBalance) public {
        vm.assume(preBalance > amount);

        address payable tester = payable(address(0x1337));
        
        deal(tester, preETHBalance);
        deal(address(weth), tester, preBalance);

        deal(address(weth), uint256(amount) + 2300);
        
        vm.prank(tester);
        weth.withdraw(amount);

        assertEq(weth.balanceOf(tester), preBalance - amount);
        assertEq(tester.balance, uint(preETHBalance) + uint(amount));
    }

    function test_ERC20_selfTransfer(uint256 value, uint96 preBalance) public {
        vm.assume(preBalance > value);

        address payable tester = payable(address(0x1337));

        deal(address(weth), tester, preBalance);

        vm.prank(tester);
        weth.transfer(tester, value);

        assertEq(weth.balanceOf(tester), preBalance);
    }
}
