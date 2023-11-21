// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IAttackSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IAttackSystem {
  function AttackTarget(bytes32 attacker_key, bytes32 target_key, uint8 slot, bool skip_cost) external;

  function AttackPlayer(bytes32 card_key, uint8 slot, bytes32 player_key, bool skip_cost) external;
}
