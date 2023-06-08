# Molten Pools

_A System for Managed, Delegated Voting on Governor Bravo_

Molten Pools serve as recipients of delegated votes from governance token
holders, which can then be channeled through the Molten Pool Manager contract to
influence the governance process.

## How it works

A Molten Pool interfaces with the Governor Bravo contract, allowing it to
execute governance functions such as `castVote` and `propose`.

Pools are controlled by a Molten Pool Manager contract, which has the exclusive
authority to call these functions on the Pool through its own `castVoteViaPool`
and `proposeViaPool` functions.

An account must be designated as the Pool's Delegate in the Manager's
`poolDelegate` mapping to gain the authority to call these functions. This
mapping can only be modified by the owner of the Manager contract, thereby
enforcing a permissioned setup.

## Example Usage Scenario

1. Butter creates a Molten Pool Manager and a Pool specifically for Uniswap..
2. Tokenholders delegate to the Pool.
3. Upon completion of a Butter election, the Pool's Delegate is set by Butter to
   the election winner. Consequently, the election winner is granted increased
   voting power and proposal rights on Uniswap through the Pool, by invoking
   `castVoteViaPool` and `proposeViaPool` on the Manager contract.
4. Once the Delegation Campaign period ends, Butter resets the Pool's Delegate,
   effectively revoking their enhanced voting and proposal rights.

## Caveat

This system is inherently permissioned, meaning the owner of the Pool Manager
has the capacity to revoke delegatee access at any point.

A permissionless setup would require rules, eg. define a Pool's Delegate for
fixed period of 3 months.

For such functionality, see [Alligator by
Agora](https://github.com/voteagora/liquid-delegator).
