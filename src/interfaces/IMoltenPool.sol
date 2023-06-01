// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {MoltenPool} from "../MoltenPool.sol";

interface IMoltenPool {
    function castVote(uint256 proposalId, uint8 support) external;
}
