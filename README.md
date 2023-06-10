# Molten Pools

_A delegation extension pack for Governor Bravo_

Molten Pools serve as recipients of delegated votes from governance token
holders, which can then be channeled through the Molten Pool Manager contract to
exert governance rights.

## Rationale

Molten Pools is a technical implementation of Butter's [Delegation Partner Pool
Program](https://butterd.notion.site/Butter-Delegation-Partner-Pools-ac1f44173eb54ebb8a9e12b74af20805)
designed to address imbalance in DAO governance. Molten Pools allow large DAO
tokenholders to pool their voting power and let tokenholders control
distribution of this voting power via Butter's elections.

This process aims at being credibly neutral thus promoting transparency and
integrity in decision-making.

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

## Caveats

### Permissions

Control over the delegated voting rights is permissioned to the owner of the
Manager contract. In particular, the owner has the capacity to revoke delegatee
access at any point.

To improve on this, 2 options are avaialble:

- [Implement Pools with specific
  logic](https://github.com/butterymoney/molten-pools/issues/1)
- Use a rules-based contract like
  [Alligator](https://github.com/voteagora/liquid-delegator).



### Splitting delegations

As long as Governor contracts don't implement some form of [fractional
voting](github.com/ScopeLift/flexible-voting), there is no way to implement
delegation Pools which split their delegation to multiple recipient Delegates.

Other smart contracts designed to hold actual tokens, like
[Franchiser](github.com/NoahZinsmeister/franchiser), can achieve this at the
cost of higher trust.
