pragma solidity >=0.8.21;

import "../codegen/common.sol";

import {Matches, MatchesExtended, PlayerCardsBoard, CardOnBoards} from "../codegen/index.sol";
import {GameState, SelectorType, Status} from "../codegen/common.sol";

import "./CardLogicLib.sol";
import {Slot, SlotLib} from "./SlotLib.sol";
import {PlayerLogicLib} from "./PlayerLogicLib.sol";
import {CardLogicLib} from "./CardLogicLib.sol";

library BaseLogicLib {

    function IsPlayerTurn(bytes32 match_key, bytes32 player_key) internal view returns (bool) {
        return IsPlayerActionTurn(match_key, player_key) || IsPlayerSelectorTurn(match_key, player_key);
    }

    function IsPlayerActionTurn(bytes32 match_key, bytes32 player_key) internal view returns (bool) {
        return player_key != 0
        && Matches.getCurrentPlayer(match_key) == player_key
        && Matches.getGameState(match_key) == GameState.PLAY
        && MatchesExtended.getSelector(match_key) == SelectorType.NONE;
    }

    function IsPlayerSelectorTurn(bytes32 match_key, bytes32 player_key) internal view returns (bool) {
        return player_key != 0
        && MatchesExtended.getSelectorPlayerId(match_key) == player_key
        && Matches.getGameState(match_key) == GameState.PLAY
        && MatchesExtended.getSelector(match_key) != SelectorType.NONE;
    }

    function CanPlayCard(bytes32 card_key, Slot memory slot, bool skip_cost) internal view returns (bool) {
        //todo

        //        if (card == null)
        //            return false;
        //

        if (!skip_cost) {
            return false;
        }

        //        Player player = GetPlayer(card.player_id);
        //        if (!skip_cost && !player.CanPayMana(card))
        //            return false; //Cant pay mana
        //        if (!player.HasCard(player.cards_hand, card))
        //            return false; // Card not in hand
        //
        //        if (card.CardData.IsBoardCard())
        //        {
        //            if (!slot.IsValid() || IsCardOnSlot(slot))
        //                return false;   //Slot already occupied
        //            if (Slot.GetP(card.player_id) != slot.p)
        //                return false; //Cant play on opponent side
        //            return true;
        //        }

        if (CardLogicLib.IsBoardCard(card_key)) {
            if (!SlotLib.IsValid(slot)) {// || CardLogicLib.IsCardOnSlot(slot)) {
                return false;
            }
            return true;
        }

        //        if (card.CardData.IsEquipment())
        //        {
        //            if (!slot.IsValid())
        //                return false;
        //
        //            Card target = GetSlotCard(slot);
        //            if (target == null || target.CardData.type != CardType.Character || target.player_id != card.player_id)
        //        return false; //Target must be an allied character
        //
        //        return true;
        //        }
        //        if (card.CardData.IsRequireTargetSpell())
        //        {
        //            return IsPlayTargetValid(card, slot); //Check play target on slot
        //        }
        //        return true;

        return true;
    }

    function CanMoveCard(bytes32 card_key, Slot memory slot) internal view returns (bool) {
        //todo

        if (SlotLib.IsValid(slot)) {
            return false;
        }

        if (CardLogicLib.IsBoardCard(card_key)) {
            return false;
        }


        //        if (card == null || !slot.IsValid())
        //            return false;
        //
        //        if (!IsOnBoard(card))
        //            return false; //Only cards in play can move
        //
        //        if (!card.CanMove(skip_cost))
        //            return false; //Card cant move
        //
        //        if (Slot.GetP(card.player_id) != slot.p)
        //            return false; //Card played wrong side
        //
        //        if (card.slot == slot)
        //            return false; //Cant move to same slot
        //
        //        Card slot_card = GetSlotCard(slot);
        //        if (slot_card != null)
        //            return false; //Already a card there

        return true;
    }

    function CanAttackTarget(bytes32 attacker, bytes32 target, bool skip_cost) internal pure returns (bool) {

        if (attacker == 0 || target == 0)
            return false;

        if (!PlayerLogicLib.CanAttack(skip_cost))
            return false;

        if (attacker == target)
            return false;

        if (!CardLogicLib.IsOnBoard(attacker) || !CardLogicLib.IsCharacter(attacker))
            return false;

        if (CardLogicLib.HasStatus(target, Status.PROTECTED) && !CardLogicLib.HasStatus(attacker, Status.FLYING))
            return false;

        return true;
    }

    function CanCastAbility(bytes32 card_key) internal pure returns (bool) {

//        if (ability == null || card == null || !card.CanDoActivatedAbilities())
//            return false; //This card cant cast
//
//        if (ability.trigger != AbilityTrigger.Activate)
//            return false; //Not an activated ability
//
//        Player player = GetPlayer(card.player_id);
//        if (!player.CanPayAbility(card, ability))
//            return false; //Cant pay for ability
//
//        if (!ability.AreTriggerConditionsMet(this, card))
//            return false; //Conditions not met
//
//        return true;

        //todo
        return true;
    }

    function CanSelectAbility() internal pure returns (bool) {
        //todo
        return true;
    }

    function GetSlotCard(bytes32 game_key, Slot memory slot) internal view returns (bytes32) {

        bytes32[] memory players = Matches.getPlayers(game_key);

        for (uint i = 0; i < players.length; i++) {
            bytes32 player_key = players[i];
            bytes32[] memory cards_board = PlayerCardsBoard.getValue(player_key);
            for (uint j = 0; j < cards_board.length; j++) {
                bytes32 card = cards_board[j];
                if (card != 0 && CardOnBoards.getSlot(card) == SlotLib.EncodeSlot(slot)) {
                    return card;
                }
            }
        }

        return 0;
    }
}

