// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IGovernorBravo} from "../../src/interfaces/IGovernorBravo.sol";

contract GovernorBravoMock is IGovernorBravo {
    struct __CastVoteCall {
        uint256 proposalId;
        uint8 support;
    }
    __CastVoteCall public __castVoteCalledWith;

    function castVote(uint256 proposalId, uint8 support) public {
        __castVoteCalledWith = __CastVoteCall(proposalId, support);
    }
}
