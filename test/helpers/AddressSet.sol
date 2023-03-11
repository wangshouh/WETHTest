// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


struct AddressSet {
	address[] addrs;
	mapping(address => bool) saved;
}

library LibAddressSet {
	function add(AddressSet storage s, address addr) internal {
		if (!s.saved[addr]) {
			s.addrs.push(addr);
			s.saved[addr] = true;
		}
	}

	function rand(AddressSet storage s, uint256 seed) internal view returns (address) {
		if (s.addrs.length > 0) {
			return s.addrs[seed % s.addrs.length];
		} else {
			return address(0);
		}
	}

	function forEach(
		AddressSet storage s,
		function(address) external returns (uint256) func
	) internal returns (uint256[] memory) {
		uint256[] memory arr = new uint256[](s.addrs.length);
		for (uint256 i; i < s.addrs.length; ++i) {
			arr[i] = func(s.addrs[i]);
		}
		return arr;
	}
}