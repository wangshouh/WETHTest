// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WETH.sol";
import "./handlers/Handler.sol";

contract WETHInvariants is Test {
    WETH9 public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH9();
        handler = new Handler(weth);

        bytes4[] memory selectors = new bytes4[](7);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendFallback.selector;
        selectors[3] = Handler.approve.selector;
        selectors[4] = Handler.transfer.selector;
        selectors[5] = Handler.transferFrom.selector;
        selectors[6] = Handler.forcePush.selector;

        targetSelector(FuzzSelector({
            addr: address(handler),
            selectors: selectors
        }));

        excludeSender(address(weth));

        targetContract(address(handler));
    }

    function invariant_solvencyDeposits() public {
        uint256[] memory balanceArray = handler.actorForEach(weth.balanceOf);
        uint256 actorWETHSum = sum(balanceArray);
        
        assertEq(
            address(weth).balance - handler.ghost_forcePushSum(),
            // handler.ghost_depositSum() - handler.ghost_withdrawSum()
            actorWETHSum
        );
    }

    function sum(uint256[] memory uintList) internal pure returns (uint256) {
        uint256 sumResult = 0;
        for (uint256 i; i < uintList.length; ++i) {
            sumResult += uintList[i];
        }
        return sumResult;
    }
}