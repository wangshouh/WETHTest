// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.7;

contract FormalVerify {

	mapping(address => uint256) public balanceOf;

	function errorTansfer(address dst, uint256 wad, uint256 initBalance) public {
		balanceOf[msg.sender] = initBalance;
		require(balanceOf[msg.sender] > wad);

		uint256 srcBalance = balanceOf[msg.sender];
		uint256 dstBalance = balanceOf[dst];

		uint256 sumBefore = srcBalance + dstBalance;

		balanceOf[msg.sender] = srcBalance - wad;
		balanceOf[dst] = dstBalance + wad;

		
		uint256 sumAfter = balanceOf[msg.sender] + balanceOf[dst];

		assert(sumBefore == sumAfter);
	}
}