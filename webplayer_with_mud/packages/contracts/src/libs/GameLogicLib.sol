// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";
import {Matches, Cards, CardsData} from "../codegen/index.sol";
import {PlayerLogicLib} from "../libs/PlayerLogicLib.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType} from "../codegen/common.sol";

library GameLogicLib {

    //public virtual void DamagePlayer(Card attacker, Player target, int value)
    //{
    ////Damage player
    //target.hp -= value;
    //target.hp = Mathf.Clamp(target.hp, 0, target.hp_max);
    //
    ////Lifesteal
    //Player aplayer = game_data.GetPlayer(attacker.player_id);
    //if (attacker.HasStatus(StatusType.LifeSteal))
    //aplayer.hp += value;
    //}

    function DamagePlayer(bytes32 player, uint256 value) internal {
        //        player.hp -= value;
        //        player.hp = Math.clamp(player.hp, 0, player.hp_max);
        //todo
    }

    function UpdateOngoing() internal {
        //todo
    }

    function HealCard(bytes32 target, uint8 value) internal {
        //todo
    }

    function EquipCard(bytes32 card, bytes32 equipment) internal {
        //todo
    }

    function CheckForWinner(bytes32 game_key) internal {
        uint8 count_alive = 0;
        bytes32 alive = 0;
        bytes32[] memory players = Matches.getPlayers(game_key);
        for (uint8 i = 0; i < players.length; i++) {
            bytes32 player = players[i];
            if (!PlayerLogicLib.IsDead(player)) {
                alive = player;
                count_alive++;
            }
        }
        if (count_alive == 0) {
            EndGame(game_key, 0);
        } else if (count_alive == 1) {
            EndGame(game_key, alive);
        }
    }

    function EndGame(bytes32 game_key, bytes32 winner) internal {
//        if (game_data.state != GameState.GameEnded)
//        {
//            game_data.state = GameState.GameEnded;
//            game_data.phase = GamePhase.None;
//            game_data.selector = SelectorType.None;
//            game_data.current_player = winner; //Winner player
//            resolve_queue.Clear();
//            Player player = game_data.GetPlayer(winner);
//            onGameEnd?.Invoke(player);
//        }
        //todo
        if (Matches.getGameState(game_key) != GameState.GAME_ENDED) {
            Matches.setGameState(game_key, GameState.GAME_ENDED);
            Matches.setGamePhase(game_key, GamePhase.NONE);
            Matches.setCurrentPlayer(game_key, winner);
        }
    }

    ////Heal a card
    //public virtual void HealCard(Card target, int value)
    //{
    //if (target == null)
    //return;
    //
    //if (target.HasStatus(StatusType.Invincibility))
    //return;
    //
    //target.damage -= value;
    //target.damage = Mathf.Max(target.damage, 0);
    //}

}