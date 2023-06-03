// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IMoltenPermissionedPoolManager} from "./interfaces/IMoltenPermissionedPoolManager.sol";
import {IMoltenPermissionedPoolManagerErrors} from "./interfaces/IMoltenPermissionedPoolManagerErrors.sol";
import {MoltenPool} from "./MoltenPool.sol";
import {Owned} from "solmate/auth/Owned.sol";

contract MoltenPermissionedPoolManager is
    IMoltenPermissionedPoolManager,
    IMoltenPermissionedPoolManagerErrors,
    Owned
{
    mapping(address pool => address delegate) public poolDelegate;

    event DelegateSet(address indexed pool, address indexed delegate);

    constructor(address _owner) Owned(_owner) {}

    function setDelegate(address pool, address delegate) public onlyOwner {
        poolDelegate[pool] = delegate;

        emit DelegateSet(pool, delegate);
    }

    function castVoteOfPool(
        address pool,
        uint256 proposalId,
        uint8 support
    ) public {
        if (msg.sender != poolDelegate[pool])
            revert NotDelegate(pool, msg.sender);

        MoltenPool(pool).castVote(proposalId, support);
    }
}
