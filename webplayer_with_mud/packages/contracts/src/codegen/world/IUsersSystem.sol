// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

import { UsersData } from "./../index.sol";

/**
 * @title IUsersSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IUsersSystem {
  function addUser(string memory username) external returns (bytes32 key);

  function getUser() external view returns (UsersData memory _table);

  function getUserByKey(bytes32 key) external view returns (UsersData memory _table);

  function getUserByOwner(address owner) external view returns (UsersData memory _table);
}
