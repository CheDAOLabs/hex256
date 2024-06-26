// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {SystemSwitch} from "@latticexyz/world-modules/src/utils/SystemSwitch.sol";
import {GamesExtended, CardOnBoards, PlayerActionHistory, ActionHistory, Ability} from "../codegen/index.sol";
import {SelectorType, Action, AbilityTarget} from "../codegen/common.sol";
import {Slot, SlotLib} from "../libs/SlotLib.sol";
import {IAbilitySystem} from "../codegen/world/IAbilitySystem.sol";
import {IOnGoingSystem} from "../codegen/world/IOnGoingSystem.sol";
import {ConditionTargetType} from "../codegen/common.sol";

contract SelectSystem is System {
    function SelectCard(bytes32 game_uid, bytes32 target) public {
        SelectorType selector = GamesExtended.getSelector(game_uid);

        if (selector == SelectorType.None) {
            return;
        }

        bytes32 caster = GamesExtended.getSelectorCasterUid(game_uid);
        bytes32 ability_key = GamesExtended.getSelectorAbility(game_uid);
        AbilityTarget target_type = Ability.getTarget(ability_key);

        if (caster == 0 || target == 0 || ability_key == 0)
            return;

        if (selector == SelectorType.SelectTarget) {
//            if (!ability.CanTarget(game_data, caster, target))
//                return; //Can't target that target
//
//            Player player = game_data.GetPlayer(caster.player_id);
//            if (!is_ai_predict)
//                player.AddHistory(GameAction.CastAbility, caster, ability, target);
//
//            game_data.selector = SelectorType.None;
//            ResolveEffectTarget(ability, caster, target);
//            AfterAbilityResolved(ability, caster);
//            resolve_queue.ResolveAll();

            GamesExtended.setSelector(game_uid, SelectorType.None);
            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.ResolveEffectTarget, (game_uid, ability_key, caster, target, target_type, ConditionTargetType.Card))
            );
            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.AfterAbilityResolved, (game_uid, ability_key, target_type, caster))
            );
            uint256 len = PlayerActionHistory.length(game_uid);
            bytes32 action_key = keccak256(abi.encode(game_uid, len));
            PlayerActionHistory.push(game_uid, action_key);
            ActionHistory.setActionType(action_key, Action.SelectCard);
        } else if (selector == SelectorType.SelectorChoice) {
//            if (!ability.IsCardSelectionValid(game_data, caster, target, card_array))
//                return; //Supports conditions and filters
//
            GamesExtended.setSelector(game_uid, SelectorType.None);
//            game_data.selector = SelectorType.None;
//            ResolveEffectTarget(ability, caster, target);
//            AfterAbilityResolved(ability, caster);
//            resolve_queue.ResolveAll();


            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerCardAbility, (game_uid, ability_key, caster, target, ConditionTargetType.Card))
            );

            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.AfterAbilityResolved, (game_uid, ability_key, target_type, caster))
            );

            SystemSwitch.call(
                abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_uid))
            );

        } else if (selector == SelectorType.SelectorCard) {

            //todo
//            if (!ability.IsCardSelectionValid(game_data, caster, target, card_array))
//                return; //Supports conditions and filters
//
//            game_data.selector = SelectorType.None;
//            ResolveEffectTarget(ability, caster, target);
//            AfterAbilityResolved(ability, caster);
//            resolve_queue.ResolveAll();

            GamesExtended.setSelector(game_uid, SelectorType.None);

            AbilityTarget ability_target = Ability.getTarget(ability_key);

            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.ResolveEffectTarget, (game_uid, ability_key, caster, target, ability_target, ConditionTargetType.Card))
            );

            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.AfterAbilityResolved, (game_uid, ability_key, target_type, caster))
            );

            SystemSwitch.call(
                abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_uid))
            );


        } else {
            revert("SelectCard: selector type not supported");
        }
    }

    function SelectPlayer(bytes32 game_uid, bytes32 target) public {
        SelectorType selector = GamesExtended.getSelector(game_uid);
        if (selector == SelectorType.None) {
            return;
        }

        bytes32 caster = GamesExtended.getSelectorCasterUid(game_uid);
        bytes32 ability_key = GamesExtended.getSelectorAbility(game_uid);

        if (caster == 0 || target == 0 || ability_key == 0)
            return;

        if (selector == SelectorType.SelectTarget) {

            SystemSwitch.call(
                abi.encodeCall(IAbilitySystem.TriggerCardAbility, (game_uid, ability_key, caster, target, ConditionTargetType.Player))
            );

            uint256 len = PlayerActionHistory.length(game_uid);
            bytes32 action_key = keccak256(abi.encode(game_uid, len));
            PlayerActionHistory.push(game_uid, action_key);
            ActionHistory.setActionType(action_key, Action.SelectPlayer);
        }

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_uid))
        );
    }

    function SelectSlot(bytes32 game_uid, uint16 slot_encode) public {
        SelectorType selector = GamesExtended.getSelector(game_uid);
        if (selector == SelectorType.None) {
            return;
        }

        Slot memory target = SlotLib.DecodeSlot(slot_encode);

        bytes32 caster = GamesExtended.getSelectorCasterUid(game_uid);
        bytes32 ability_key = GamesExtended.getSelectorAbility(game_uid);

        if (caster == 0 || ability_key == 0 || !SlotLib.IsValid(target))
            return;

        if (selector == SelectorType.SelectTarget) {
            uint256 len = PlayerActionHistory.length(game_uid);
            bytes32 action_key = keccak256(abi.encode(game_uid, len));
            PlayerActionHistory.push(game_uid, action_key);
            ActionHistory.setActionType(action_key, Action.SelectSlot);
        }

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_uid))
        );
    }

    function SelectChoice(bytes32 game_uid, uint8 choice) public {
        SelectorType selector = GamesExtended.getSelector(game_uid);
        if (selector == SelectorType.None) {
            return;
        }

        bytes32 caster = GamesExtended.getSelectorCasterUid(game_uid);
        bytes32 ability_key = GamesExtended.getSelectorAbility(game_uid);

        if (caster == 0 || ability_key == 0 || choice < 0) {
            return;
        }

        AbilityTarget ability_target = Ability.getTarget(ability_key);
        if (selector == SelectorType.SelectorChoice && ability_target == AbilityTarget.ChoiceSelector)
        {
            uint256 len = PlayerActionHistory.length(game_uid);
            bytes32 action_key = keccak256(abi.encode(game_uid, len));
            PlayerActionHistory.push(game_uid, action_key);
            ActionHistory.setActionType(action_key, Action.SelectChoice);
        }

        SystemSwitch.call(
            abi.encodeCall(IOnGoingSystem.UpdateOngoing, (game_uid))
        );
    }

    function CancelSelection(bytes32 game_uid) public {
        SelectorType selector = GamesExtended.getSelector(game_uid);
        if (selector != SelectorType.None)
        {
            GamesExtended.setSelector(game_uid, SelectorType.None);

            uint256 len = PlayerActionHistory.length(game_uid);
            bytes32 action_key = keccak256(abi.encode(game_uid, len));
            PlayerActionHistory.push(game_uid, action_key);
            ActionHistory.setActionType(action_key, Action.CancelSelect);
            return;
        }
    }

}