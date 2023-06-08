// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract DelegateeActions {
    struct __CastVoteCall {
        uint256 proposalId;
        uint8 support;
    }
    __CastVoteCall public __castVoteCalledWith;

    struct __ProposeCall {
        address[] targets;
        uint256[] values;
        string[] signatures;
        bytes[] calldatas;
        string description;
    }
    __ProposeCall private __proposeCalledWith;

    function __proposeCalledWith_targets()
        public
        view
        returns (address[] memory)
    {
        return __proposeCalledWith.targets;
    }

    function __proposeCalledWith_values()
        public
        view
        returns (uint256[] memory)
    {
        return __proposeCalledWith.values;
    }

    function __proposeCalledWith_signatures()
        public
        view
        returns (string[] memory)
    {
        return __proposeCalledWith.signatures;
    }

    function __proposeCalledWith_calldatas()
        public
        view
        returns (bytes[] memory)
    {
        return __proposeCalledWith.calldatas;
    }

    function __proposeCalledWith_description()
        public
        view
        returns (string memory)
    {
        return __proposeCalledWith.description;
    }

    function castVote(uint256 proposalId, uint8 support) public {
        __castVoteCalledWith = __CastVoteCall(proposalId, support);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) public returns (uint256) {
        __proposeCalledWith.targets = targets;
        __proposeCalledWith.values = values;
        __proposeCalledWith.signatures = signatures;
        __proposeCalledWith.calldatas = calldatas;
        __proposeCalledWith.description = description;
        return 0;
    }
}
