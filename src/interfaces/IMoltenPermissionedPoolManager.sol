// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {MoltenPermissionedPoolManager} from "../MoltenPermissionedPoolManager.sol";

interface IMoltenPermissionedPoolManager {
    function setDelegate(address pool, address delegate) external;

    function castVoteOfPool(
        address pool,
        uint256 proposalId,
        uint8 support
    ) external;
}
