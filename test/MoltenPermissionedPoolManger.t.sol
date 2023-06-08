// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {MoltenPermissionedPoolManager} from "../src/MoltenPermissionedPoolManager.sol";
import {IMoltenPermissionedPoolManagerErrors} from "../src/interfaces/IMoltenPermissionedPoolManagerErrors.sol";
import {MoltenPoolMock} from "./utils/MoltenPoolMock.sol";

contract ManagerCreationTest is Test {
    function testSetsOwner(address owner) public {
        MoltenPermissionedPoolManager manager = new MoltenPermissionedPoolManager(
                owner
            );

        assertEq(manager.owner(), owner);
    }
}

contract SetDelegateTest is Test {
    address owner = address(0x4242);
    MoltenPermissionedPoolManager manager;

    function setUp() public {
        manager = new MoltenPermissionedPoolManager(owner);
    }

    function testAuthFails(
        address caller,
        address pool,
        address delegate
    ) public {
        vm.assume(caller != owner);

        vm.prank(caller);
        vm.expectRevert("UNAUTHORIZED");
        manager.setDelegate(pool, delegate);
    }

    function testUpdatespoolDelegate(address pool, address delegate) public {
        vm.prank(owner);
        manager.setDelegate(pool, delegate);

        assertEq(manager.poolDelegate(pool), delegate);
    }
}

contract CastPoolVoteTest is Test, IMoltenPermissionedPoolManagerErrors {
    address owner = address(0x4242);
    MoltenPoolMock pool;
    address governor = address(0x4141);
    address delegate = address(0x4444);
    MoltenPermissionedPoolManager manager;

    function setUp() public {
        manager = new MoltenPermissionedPoolManager(owner);
        pool = new MoltenPoolMock();
        vm.prank(owner);
        manager.setDelegate(address(pool), delegate);
    }

    function testForbidden(
        address caller,
        uint256 proposalId,
        uint8 support
    ) public {
        vm.assume(caller != delegate);

        vm.prank(caller);
        vm.expectRevert(
            abi.encodeWithSelector(NotDelegate.selector, address(pool), caller)
        );
        manager.castVoteViaPool(address(pool), proposalId, support);
    }

    function testCallsPool(uint256 proposalId, uint8 support) public {
        vm.prank(delegate);
        manager.castVoteViaPool(address(pool), proposalId, support);

        (uint256 _proposalId, uint8 _support) = pool.__castVoteCalledWith();
        assertEq(_proposalId, proposalId);
        assertEq(_support, support);
    }
}

contract PoolProposeTest is Test, IMoltenPermissionedPoolManagerErrors {
    address owner = address(0x4242);
    MoltenPoolMock pool;
    address governor = address(0x4141);
    address delegate = address(0x4444);
    MoltenPermissionedPoolManager manager;

    function setUp() public {
        manager = new MoltenPermissionedPoolManager(owner);
        pool = new MoltenPoolMock();
        vm.prank(owner);
        manager.setDelegate(address(pool), delegate);
    }

    function testForbidden(
        address caller,
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) public {
        vm.assume(caller != delegate);

        vm.prank(caller);
        vm.expectRevert(
            abi.encodeWithSelector(NotDelegate.selector, address(pool), caller)
        );
        manager.proposeViaPool(
            address(pool),
            targets,
            values,
            signatures,
            calldatas,
            description
        );
    }

    struct __ProposeCall {
        address[] targets;
        uint256[] values;
        string[] signatures;
        bytes[] calldatas;
        string description;
    }

    function testCallsPool(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) public {
        vm.prank(delegate);
        manager.proposeViaPool(
            address(pool),
            targets,
            values,
            signatures,
            calldatas,
            description
        );

        assertEq(pool.__proposeCalledWith_targets().length, targets.length);
        assertEq(pool.__proposeCalledWith_values().length, values.length);
        assertEq(
            pool.__proposeCalledWith_signatures().length,
            signatures.length
        );
        assertEq(pool.__proposeCalledWith_calldatas().length, calldatas.length);
        assertEq(pool.__proposeCalledWith_description(), description);
    }
}
