// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IGameStartSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IGameStartSystem {
  function GameSetting(string memory game_uid) external;

  function AddCard(
    string memory game_uid,
    string memory player_name,
    string memory card_name
  ) external returns (bytes32);

  function PlayerSetting(
    string memory username,
    string memory game_uid,
    string memory desk_id,
    bool is_ai,
    int8 hp,
    int8 mana,
    int8 dcards,
    bool need_shuffle
  ) external returns (bytes32[] memory);

  function GetPlayerByGame(bytes32 game_key) external view returns (bytes32[] memory players);

  function GetGameExtend(bytes32 game_key) external view returns (uint, bytes32, bytes32, bytes32);

  function GetCard(bytes32 card_key) external view returns (int8 hp, int8 mana, int8 attack, int8 damage);

  function setMana(bytes32 game_key) external;

  function getPlayerCards(
    bytes32 player_key
  )
    external
    view
    returns (
      string memory name,
      bytes32[] memory cards,
      bytes32[] memory hand,
      bytes32[] memory deck,
      bytes32[] memory board,
      int8 mana,
      int8 hp
    );
}
