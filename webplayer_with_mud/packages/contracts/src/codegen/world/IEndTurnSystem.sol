// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { EndTurnResultData } from "./../index.sol";

/**
 * @title IEndTurnSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IEndTurnSystem {
  function EndTurn(bytes32 game_key, uint8 player_index) external returns (EndTurnResultData memory result);
}