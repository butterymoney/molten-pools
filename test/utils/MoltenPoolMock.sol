// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IMoltenPool} from "../../src/interfaces/IMoltenPool.sol";

contract MoltenPoolMock is IMoltenPool {
    struct __CastVoteCall {
        uint256 proposalId;
        uint8 support;
    }
    __CastVoteCall public __castVoteCalledWith;

    function castVote(uint256 proposalId, uint8 support) public {
        __castVoteCalledWith = __CastVoteCall(proposalId, support);
    }
}
