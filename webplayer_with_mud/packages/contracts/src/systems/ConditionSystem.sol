// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {FunctionSelectors} from "@latticexyz/world/src/codegen/tables/FunctionSelectors.sol";
import {ResourceId} from "@latticexyz/world/src/WorldResourceId.sol";
import {Condition, ConditionCardType, CardOnBoards, Cards, Games, GamesExtended, Players} from "../codegen/index.sol";
import {PlayerCardsBoard, PlayerCardsHand, PlayerCardsEquip, PlayerCardsEquip, PlayerCardsDeck, PlayerCardsTemp, PlayerCardsDiscard, PlayerCardsSecret} from "../codegen/index.sol";
import {Status, ConditionObjType, ConditionStatType, CardType, CardTeam, ConditionPlayerType, PileType, CardTrait, ConditionOperatorInt, ConditionOperatorBool, ConditionTargetType} from "../codegen/common.sol";
import {CardPosLogicLib} from "../libs/CardPosLogicLib.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {CardLogicLib} from "../libs/CardLogicLib.sol";

contract ConditionSystem is System {

    constructor() {

    }

    function IsConditionFunctionExist(bytes4 selector) public view returns (bool){
        (ResourceId systemId, bytes4 systemFunctionSelector) = FunctionSelectors.get(selector);
        if (ResourceId.unwrap(systemId) == 0) {
            return false;
        }
        return true;
    }


    function IsTriggerConditionMet(bytes4 condition, bytes32 game_uid, bytes32 ability_key, bytes32 caster, ConditionTargetType condition_type) public view returns (bool)
    {
        if (!IsConditionFunctionExist(condition)) {
            return true;
        }

        bytes memory data = abi.encodeWithSelector(condition, game_uid, ability_key, caster, condition_type);
        //todo
//        SystemSwitch.call(data);

        return true;
    }


    function IsTargetConditionMet(bytes4 condition, bytes32 game_uid, bytes32 ability_key, bytes32 caster, bytes32 target, ConditionTargetType condition_type) public view returns (bool)
    {
        if (!IsConditionFunctionExist(condition)) {
            return true;
        }


        bytes memory data = abi.encodeWithSelector(condition, game_uid, ability_key, caster, condition_type);
        //todo
//        SystemSwitch.call(data);

        return true;
    }

    //================================================================================

    //(Game data, AbilityData ability, Card caster, CardData target)
//{
//bool is_type = target.type == has_type || has_type == CardType.None;
//bool is_team = target.team == has_team || has_team == null;
//bool is_trait = target.HasTrait(has_trait) || has_trait == null;
//return (is_type && is_team && is_trait);

    function HasBoardCardEnemy(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCount(condition_type,  caster, target, ConditionPlayerType.Opponent, PileType.Board, ConditionOperatorInt.GreaterEqual, CardType.None, CardTeam.None, 1);
    }

    function HasBoardCardSelf(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCount(condition_type, caster, target, ConditionPlayerType.Self, PileType.Board, ConditionOperatorInt.GreaterEqual, CardType.None, CardTeam.None, 1);

    }

    function HasDiscardCharacters(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCount(condition_type, caster, target, ConditionPlayerType.Self, PileType.Discard, ConditionOperatorInt.GreaterEqual, CardType.None, CardTeam.None, 1);

    }

    function HasBoardCharacters2(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCount(condition_type, caster, target, ConditionPlayerType.Self, PileType.Board, ConditionOperatorInt.GreaterEqual, CardType.None, CardTeam.None, 2);

    }

    function HasDiscardSpell(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCount(condition_type, caster, target, ConditionPlayerType.Self, PileType.Discard, ConditionOperatorInt.GreaterEqual, CardType.Spell, CardTeam.None, 1);
    }

    function AiIsAlly(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionOwnerAI(ability_key, caster, target, ConditionOperatorBool.IsFalse);
    }

    function AiIsEnemy(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionOwnerAI(ability_key, caster, target, ConditionOperatorBool.IsTrue);
    }

    function IsAlly(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionOwner(ability_key, caster, target, ConditionOperatorBool.IsTrue);
    }

    function IsEnemy(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionOwner(ability_key, caster, target, ConditionOperatorBool.IsFalse);
    }

    function IsArtifact(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.Artifact, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsSpell(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.Spell, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsEquipment(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.Equipment, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsCharacter(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.Character, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsHero(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.Hero, CardTeam.None, CardTrait.None, ability_key, caster, target);
    }

    function IsCard(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionTarget(ConditionTargetType.Card, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsDeckBuilding(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionDeckbuilding(ability_key, caster, target, ConditionOperatorBool.IsTrue);
    }

    function IsGrowth3(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionStatCustom(ability_key, caster, target, CardTrait.Growth, ConditionOperatorInt.GreaterEqual, 3);
    }

    function IsInTemp(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Temp, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInHand(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Hand, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInDiscard(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Discard, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInDeck(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Deck, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInSecret(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Secret, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInEquipment(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Equipped, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsInBoard(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardPile(PileType.Board, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }


    function IsSlot(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionTarget(ConditionTargetType.Slot, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsSlotX1(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionSlotValue(ability_key, caster, target, ConditionOperatorInt.Equal, 1, ConditionOperatorInt.GreaterEqual, 0);
    }

    function IsSlotSameP(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionSlotRange(ability_key, caster, target, 99, 99, 0);
    }

    function IsSlotNextTo(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionSlotRange(ability_key, caster, target, 1, 1, 0);
    }

    function IsSlotInRange(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionSlotRange(ability_key, caster, target, 1, 1, 1);
    }

    function IsSlotEmpty(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionSlotEmpty(ability_key, caster, target, ConditionOperatorBool.IsFalse);
    }

    function IsPlayer(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionTarget(ConditionTargetType.Player, ConditionOperatorBool.IsTrue, ability_key, caster, target);
    }

    function IsWolf(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.None, CardTeam.None, CardTrait.Wolf, ability_key, caster, target);
    }

    function IsDragon(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.None, CardTeam.None, CardTrait.Dragon, ability_key, caster, target);
    }

    function IsGreen(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Green, CardTrait.None, ability_key, caster, target);
    }

    function IsRed(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Red, CardTrait.None, ability_key, caster, target);
    }

    function IsBlue(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionCardType(CardType.None, CardTeam.Blue, CardTrait.None, ability_key, caster, target);
    }

    function IsAttackL4(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) public view returns (bool){
        return ConditionStat(ability_key, caster, target, ConditionStatType.Attack, ConditionOperatorInt.LessEqual, 4);
    }

//=======================================//=======================================//=======================================

    function ConditionCardType(CardType has_type, CardTeam has_team, CardTrait has_trait, bytes32 ability_key, bytes32 caster, bytes32 target) internal view returns (bool){
        bytes32 card_config_key = CardOnBoards.getId(target);
        bool is_type = has_type == CardType.None || Cards.getCardType(card_config_key) == has_type;
        bool is_team = has_team == CardTeam.None || Cards.getTeam(card_config_key) == has_team;
        bool is_trait = has_trait == CardTrait.None || Cards.getTrait(card_config_key) == has_trait;
        return (is_type && is_team && is_trait);
    }

    function ConditionTarget(ConditionTargetType target_type, ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal pure returns (bool){
        return CompareBool(target_type == ConditionTargetType.Card, oper); //Is Card
    }

    function ConditionCount
    (ConditionTargetType condition_type, bytes32 caster, bytes32 target, ConditionPlayerType player_type, PileType pile, ConditionOperatorInt oper, CardType has_type, CardTeam has_team, int8 value)
    internal view returns (bool)
    {
        if (condition_type != ConditionTargetType.Card) {
            return true;
        }

        int8 count = 0;

        if (player_type == ConditionPlayerType.Self || player_type == ConditionPlayerType.Both)
        {
            bytes32 player_key = CardOnBoards.getPlayerId(caster);
            count = count + CountPile(player_key, pile, has_type, has_team, CardTrait.None);
        }
        if (player_type == ConditionPlayerType.Opponent || player_type == ConditionPlayerType.Both)
        {
//todo
//            Player player = data.GetOpponentPlayer(caster.player_id);
//            count += CountPile(player, pile);
        }
        return CompareInt(count, oper, value);

    }

    function ConditionDeckbuilding(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionOperatorBool oper) internal view returns (bool){
        bytes32 card_config_key = CardOnBoards.getId(target);
        return CompareBool(Cards.getDeckbuilding(card_config_key), oper);
    }

    function ConditionExhaust(ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal view returns (bool){
        return CompareBool(CardOnBoards.getExhausted(target), oper);
    }

    function ConditionOnce(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target) internal view returns (bool){
        bytes32[] memory ability_played = GamesExtended.getAbilityPlayed(game_uid);
        for (uint i = 0; i < ability_played.length; i++) {
            if (ability_played[i] == ability_key) {
                return false;
            }
        }
        return true;
    }

    function ConditionOwner(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionOperatorBool oper) internal view returns (bool){
        bool same_owner = CardOnBoards.getPlayerId(caster) == CardOnBoards.getPlayerId(target);
        return CompareBool(same_owner, oper);
        return false;
    }

    function ConditionSlotDist(bytes32 ability_key, bytes32 caster, bytes32 target, uint8 distance, bool diagonals) internal view returns (bool){

        uint16 slot_encode = bytes32ToUint16(target);
        Slot memory target_slot = SlotLib.DecodeSlot(slot_encode);

        uint16 cslot_encode = CardOnBoards.getSlot(caster);
        Slot memory cslot = SlotLib.DecodeSlot(cslot_encode);

        if (diagonals) {
            return SlotLib.IsInDistance(cslot, target_slot, distance);
        }

        return SlotLib.IsInDistanceStraight(cslot, target_slot, distance);
    }

    function ConditionSlotEmpty(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionOperatorBool oper) internal view returns (bool){
        uint16 slot_encode = bytes32ToUint16(target);
        Slot memory slot = SlotLib.DecodeSlot(slot_encode);
        bytes32 player_key = CardOnBoards.getPlayerId(caster);
        bytes32 slot_card = SlotLib.GetCardOnSlot(player_key, slot.x);

        return CompareBool(slot_card == 0, oper);
    }

    function ConditionSlotValue(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionOperatorInt oper_x, int8 value_x, ConditionOperatorInt oper_y, int8 value_y) internal view returns (bool){

        uint16 slot_encode = bytes32ToUint16(target);
        Slot memory slot = SlotLib.DecodeSlot(slot_encode);

        bool valid_x = CompareInt((int8)(slot.x), oper_x, value_x);
        bool valid_y = CompareInt((int8)(slot.y), oper_y, value_y);
        return valid_x && valid_y;
    }

    function ConditionSlotRange(bytes32 ability_key, bytes32 caster, bytes32 target, int8 range_x, int8 range_y, int8 range_p) internal view returns (bool){
        uint16 slot_encode = bytes32ToUint16(target);
        Slot memory target_slot = SlotLib.DecodeSlot(slot_encode);

        uint16 cslot_encode = CardOnBoards.getSlot(caster);
        Slot memory cslot = SlotLib.DecodeSlot(cslot_encode);

        uint8 dist_x = uint8(cslot.x - target_slot.x);
        uint8 dist_y = uint8(cslot.y - target_slot.y);
        uint8 dist_p = uint8(cslot.p - target_slot.p);

        return dist_x <= uint8(range_x) && dist_y <= uint8(range_y) && dist_p <= uint8(range_p);
    }


    function ConditionTurn(bytes32 game_uid, bytes32 ability_key, ConditionTargetType condition_type, bytes32 caster, bytes32 target, ConditionOperatorBool oper) internal view returns (bool){
        bool yourturn = CardOnBoards.getPlayerId(caster) == Games.getCurrentPlayer(game_uid);
        return CompareBool(yourturn, oper);
    }

    function ConditionStatus(Status has_status, int8 value, ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal view returns (bool){
        (Status card_status, uint8 status_duration, uint8 status_value) = CardLogicLib.GetStatus(target, has_status);
        return card_status != Status.None && status_value >= (uint8)(value);
    }

    function ConditionOwnerAI(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionOperatorBool oper) internal view returns (bool){
//todo
        return false;
    }


    function ConditionCardPile(PileType pile_type, ConditionOperatorBool oper, bytes32 ability_key, bytes32 caster, bytes32 target) internal view returns (bool){
        if (target == 0) {
            return false;
        }
        if (pile_type == PileType.Hand) {
            return CompareBool(CardPosLogicLib.IsInHand(target), oper);
        }

        if (pile_type == PileType.Board) {
            return CompareBool(CardPosLogicLib.IsOnBoard(target), oper);
        }

        if (pile_type == PileType.Deck) {
            return CompareBool(CardPosLogicLib.IsInDeck(target), oper);
        }

        if (pile_type == PileType.Discard) {
            return CompareBool(CardPosLogicLib.IsInDiscard(target), oper);
        }

        if (pile_type == PileType.Secret) {
            return CompareBool(CardPosLogicLib.IsInSecret(target), oper);
        }

        if (pile_type == PileType.Temp) {
            return CompareBool(CardPosLogicLib.IsInTemp(target), oper);
        }

        return false;
    }

    function ConditionStat(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionStatType stat_type, ConditionOperatorInt oper, int8 value) internal view returns (bool) {
        if (stat_type == ConditionStatType.Attack)
        {
            return CompareInt(CardOnBoards.getAttack(target), oper, value);
        }

        if (stat_type == ConditionStatType.HP)
        {
            return CompareInt(CardOnBoards.getHp(target), oper, value);
        }

        if (stat_type == ConditionStatType.Mana)
        {
            return CompareInt(CardOnBoards.getMana(target), oper, value);
        }

        return false;
    }

    function ConditionPlayerStat(bytes32 ability_key, bytes32 caster, bytes32 target, ConditionStatType stat_type, ConditionOperatorInt oper, int8 value) internal view returns (bool){
        if (stat_type == ConditionStatType.HP)
        {
            return CompareInt(Players.getHp(target), oper, value);
        }

        if (stat_type == ConditionStatType.Mana)
        {
            return CompareInt(Players.getMana(target), oper, value);
        }

        return false;
    }

    function ConditionStatCustom(bytes32 ability_key, bytes32 caster, bytes32 target, CardTrait has_trait, ConditionOperatorInt oper, int8 value) internal view returns (bool){
//todo
        return false;
    }

    function CompareBool(bool condition, ConditionOperatorBool oper) internal pure returns (bool)
    {
        if (oper == ConditionOperatorBool.IsFalse)
            return !condition;
        return condition;
    }


    function CompareInt(int8 ival1, ConditionOperatorInt oper, int8 ival2) internal pure returns (bool){
        if (oper == ConditionOperatorInt.Equal)
        {
            return ival1 == ival2;
        }
        if (oper == ConditionOperatorInt.NotEqual)
        {
            return ival1 != ival2;
        }
        if (oper == ConditionOperatorInt.GreaterEqual)
        {
            return ival1 >= ival2;
        }
        if (oper == ConditionOperatorInt.LessEqual)
        {
            return ival1 <= ival2;
        }
        if (oper == ConditionOperatorInt.Greater)
        {
            return ival1 > ival2;
        }
        if (oper == ConditionOperatorInt.Less)
        {
            return ival1 < ival2;
        }
        return false;
    }

    function CountPile(bytes32 player_key, PileType pile, CardType has_type, CardTeam has_team, CardTrait has_trait) internal view returns (int8){

        int8 count = 0;
        bytes32[] memory card_pile;

        if (pile == PileType.Hand) {
            card_pile = PlayerCardsHand.getValue(player_key);
        }

        if (pile == PileType.Board) {
            card_pile = PlayerCardsBoard.getValue(player_key);
        }

        if (pile == PileType.Equipped) {
            card_pile = PlayerCardsEquip.getValue(player_key);
        }

        if (pile == PileType.Deck) {
            card_pile = PlayerCardsDeck.getValue(player_key);
        }

        if (pile == PileType.Discard) {
            card_pile = PlayerCardsDiscard.getValue(player_key);
        }

        if (pile == PileType.Secret) {
            card_pile = PlayerCardsSecret.getValue(player_key);
        }

        if (pile == PileType.Temp) {
            card_pile = PlayerCardsTemp.getValue(player_key);
        }

        if (card_pile.length > 0) {
            for (uint i = 0; i < card_pile.length; i++) {
                if (IsTrait(card_pile[i], has_type, has_team, has_trait)) {
                    count++;
                }
            }
        }
        return count;
    }

    function IsTrait(bytes32 card_key, CardType has_type, CardTeam has_team, CardTrait has_trait) internal view returns (bool){
        bytes32 card_config_key = CardOnBoards.getId(card_key);
        bool is_type = has_type == CardType.None || Cards.getCardType(card_config_key) == has_type;
        bool is_team = has_team == CardTeam.None || Cards.getTeam(card_config_key) == has_team;
        bool is_trait = has_trait == CardTrait.None || Cards.getTrait(card_config_key) == has_trait;
        return (is_type && is_team && is_trait);
    }

    function bytes32ToUint16(bytes32 data) internal pure returns (uint16) {
        return uint16(uint256(data));
    }

    function uint16ToBytes32(uint16 data) internal pure returns (bytes32) {
        return bytes32(uint256(data));
    }
}