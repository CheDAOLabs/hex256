// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards} from "../codegen/index.sol";
import {Decks, DecksData} from "../codegen/index.sol";
import {Games, GamesData} from "../codegen/index.sol";
import {Players, PlayersData} from "../codegen/index.sol";
import {PlayerCardsDeck, PlayerCardsHand} from "../codegen/index.sol";
import {CardOnBoards, CardOnBoardsData} from "../codegen/index.sol";

import {GameType, GameState, GamePhase, Action} from "../codegen/common.sol";
import {PlayerActionHistory, ActionHistory, ActionHistoryData} from "../codegen/index.sol";

//import "../logic/PlayerLogicLib.sol";
//import "../logic/CardLogicLib.sol";
//
import {BaseLogicLib} from "../libs/BaseLogicLib.sol";
import {GameLogicLib} from "../libs/GameLogicLib.sol";

import {Slot, SlotLib} from "../libs/SlotLib.sol";

contract MoveSystem is System {

    constructor() {

    }

    function MoveCard(bytes32 game_key, bytes32 player_key, bytes32 card_key, Slot memory slot) public {

        require(CardOnBoards.getId(card_key) != 0, "Card not found");
        require(Players.getOwner(player_key) == _msgSender(), "Not owner");

        if (BaseLogicLib.CanMoveCard(card_key, slot)) {
            //todo
            SlotLib.SetSlot(card_key, slot);

            GameLogicLib.UpdateOngoing();
        }

        SlotLib.ClearCardFromSlot(player_key, card_key);
        bytes32 card_on_slot = SlotLib.GetCardOnSlot(player_key, slot.x);
        if (card_on_slot != 0) {
            revert("Slot is already occupied");
        }
        SlotLib.SetCardOnSlot(player_key, card_key, slot.x);


        bytes32[] memory players = Games.getPlayers(game_key);
        uint16 slot_encode = SlotLib.EncodeSlot(slot);
        uint256 len = PlayerActionHistory.length(game_key);
        bytes32 action_key = keccak256(abi.encode(game_key, len));
        PlayerActionHistory.push(game_key, action_key);
        ActionHistory.setActionType(action_key, Action.Move);
        ActionHistory.setCardId(action_key, card_key);
        ActionHistory.setSlot(action_key, slot_encode);
        ActionHistory.setPlayerId(action_key, players[0] == player_key ? 0 : 1);

        //        if (game_data.CanMoveCard(card, slot, skip_cost))
        //        {
        //            card.slot = slot;
        //
        //            //Moving doesn't really have any effect in demo so can be done indefinitely
        //            //if(!skip_cost)
        //            //card.exhausted = true;
        //            //card.RemoveStatus(StatusEffect.Stealth);
        //            //player.AddHistory(GameAction.Move, card);
        //
        //            //Also move the equipment
        //            Card equip = game_data.GetEquipCard(card.equipped_uid);
        //            if (equip != null)
        //                equip.slot = slot;
        //
        //
        //            onCardMoved?.Invoke(card, slot);
        //            resolve_queue.ResolveAll(0.2f);
        //        }
    }


}