// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {IGovernorBravo} from "../src/interfaces/IGovernorBravo.sol";
import {GovernorBravoMock} from "./utils/GovernorBravoMock.sol";
import {MoltenPool} from "../src/MoltenPool.sol";

contract PoolCreationTest is Test {
    MoltenPool pool;

    function testSetPoolOwner(address poolManager, address governor) public {
        pool = new MoltenPool(poolManager, governor);

        assertEq(pool.owner(), poolManager);
    }
}

contract PoolCastVoteTest is Test {
    address poolManager = address(0x4242);
    GovernorBravoMock governor;
    MoltenPool pool;

    function setUp() public {
        governor = new GovernorBravoMock();
        pool = new MoltenPool(poolManager, address(governor));
    }

    function testDisallowed(
        address caller,
        uint256 proposalId,
        uint8 support
    ) public {
        vm.assume(caller != poolManager);
        vm.prank(caller);

        vm.expectRevert("UNAUTHORIZED");
        pool.castVote(proposalId, support);
    }

    function testCallsGovernor(uint256 proposalId, uint8 support) public {
        vm.prank(poolManager);
        pool.castVote(proposalId, support);

        (uint256 _proposalId, uint8 _support) = governor.__castVoteCalledWith();
        assertEq(_proposalId, proposalId);
        assertEq(_support, support);
    }
}
