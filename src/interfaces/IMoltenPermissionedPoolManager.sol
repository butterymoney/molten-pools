// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {MoltenPermissionedPoolManager} from "../MoltenPermissionedPoolManager.sol";

interface IMoltenPermissionedPoolManager {
    function setDelegate(address pool, address delegate) external;

    function castVoteViaPool(
        address pool,
        uint256 proposalId,
        uint8 support
    ) external;

    function proposeViaPool(
        address pool,
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) external returns (uint256);
}
