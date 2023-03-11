// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {WETH9} from "../../src/WETH.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {CommonBase} from "forge-std/Base.sol";
import {LibAddressSet, AddressSet} from "../helpers/AddressSet.sol";
// import {console} from "forge-std/console.sol";

contract Handler is StdUtils, StdCheats, CommonBase {
    WETH9 public weth;

    uint256 public ghost_depositSum;
    uint256 public ghost_withdrawSum;

    uint256 constant MAX_TRANSFER = 12_000_000 ether;

    using LibAddressSet for AddressSet;

    AddressSet internal _actors;

    constructor(WETH9 _weth) {
        weth = _weth;
    }

    modifier addActor(uint256 amount) {
        _actors.add(msg.sender);
        deal(msg.sender, amount);
        vm.startPrank(msg.sender);
        _;
        vm.stopPrank();
        // console.logUint(address(weth).balance);
        // emit log_named_uint("ETHBalance", address(weth).balance);
    }

    modifier useActor(uint256 seed) {
        address addr = _actors.rand(seed);
        vm.startPrank(addr);
        _;
        vm.stopPrank();
        // console.logUint(address(weth).balance);
        // emit log_named_uint("ETHBalance", address(weth).balance);
    }

    function actorForEach(
        function(address) external returns (uint256) func
    ) public returns (uint256[] memory) {
        return _actors.forEach(func);
    }

    function deposit(uint256 amount) public addActor(amount) {
        amount = bound(amount, 0, MAX_TRANSFER);
        weth.deposit{ value: amount }();
        ghost_depositSum += amount;
    }

    function withdraw(uint256 amount) public useActor(amount) {
        amount = bound(amount, 0, weth.balanceOf(msg.sender));
        weth.withdraw(amount);
        ghost_withdrawSum += amount;
    }

    function sendFallback(uint256 amount) public addActor(amount) {
        amount = bound(amount, 0, MAX_TRANSFER);
        (bool success,) = address(weth).call{ value: amount }("");
        require(success, "sendFallback failed");
        ghost_depositSum += amount;
    }

    function approve(uint256 amount, uint256 approverSeed) public useActor(amount) {
        address approver = _actors.rand(approverSeed);
        weth.approve(approver, amount);
    }

    function transfer(uint256 amount, address receiver) public useActor(amount) {
        amount = bound(amount, 0, weth.balanceOf(msg.sender));
        if (!_actors.saved[receiver]) {
            _actors.addrs.push(receiver);
            _actors.saved[receiver] = true;
            weth.transfer(receiver, amount);
        } else {
            weth.transfer(receiver, amount);
        }
    }

    function transferFrom(uint256 amount, uint256 senerSeed, uint256 receiverSeed) public {
        address receiver = _actors.rand(receiverSeed);
        address sender = _actors.rand(senerSeed);
        amount = bound(amount, 0, weth.balanceOf(sender));
        weth.transferFrom(sender, receiver, amount);
    }
}
