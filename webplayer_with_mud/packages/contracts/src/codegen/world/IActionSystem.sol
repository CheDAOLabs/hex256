// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { ActionHistoryData } from "./../index.sol";

/**
 * @title IActionSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IActionSystem {
  function GetAction(bytes32 player_key) external view returns (ActionHistoryData memory);
}
