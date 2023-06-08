// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IMoltenPool} from "./interfaces/IMoltenPool.sol";
import {IGovernorBravo} from "./interfaces/IGovernorBravo.sol";
import {Owned} from "solmate/auth/Owned.sol";

contract MoltenPool is IMoltenPool, Owned {
    address public governor;

    constructor(address _manager, address _governor) Owned(_manager) {
        governor = _governor;
    }

    function castVote(uint256 proposalId, uint8 support) public onlyOwner {
        IGovernorBravo(governor).castVote(proposalId, support);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) public onlyOwner returns (uint256) {
        return
            IGovernorBravo(governor).propose(
                targets,
                values,
                signatures,
                calldatas,
                description
            );
    }
}
