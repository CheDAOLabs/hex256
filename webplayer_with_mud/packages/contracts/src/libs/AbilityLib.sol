pragma solidity >=0.8.21;

import "../codegen/common.sol";
import {Cards, Matches, Ability, PlayerCardsBoard} from "../codegen/index.sol";
import {AbilityTrigger, AbilityTarget} from "../codegen/common.sol";

import {EffectLib} from "./EffectLib.sol";

library AbilityLib {

    function DoEffects(bytes32 ability_key, bytes32 caster_key) internal {
        bytes4[] memory effects = Ability.getEffects(ability_key);
        for (uint i = 0; i < effects.length; i++) {
            EffectLib.DoEffect(effects[i], ability_key, caster_key, 0, false);
        }
    }

    function DoEffects(bytes32 ability_key, bytes32 caster_key, bytes32 target_key) internal {
        //todo
    }



    function TriggerOtherCardsAbilityType(AbilityTrigger trigger, bytes32 triggerer) internal {
        if (trigger == AbilityTrigger.ON_PLAY_OTHER) {
            // 处理其他卡牌的触发条件为"ON_PLAY_OTHER"的能力
            // 根据triggerer触发相应的能力逻辑
            // todo: 添加对应的处理逻辑
        }
        else if (trigger == AbilityTrigger.ON_DEATH_OTHER) {
            // 处理其他卡牌的触发条件为"ON_DEATH_OTHER"的能力
            // 根据triggerer触发相应的能力逻辑
            // todo: 添加对应的处理逻辑
        }
        else {
            // 其他未定义的触发条件类型，可以根据需要进行处理
        }
    }

    function TriggerCardAbilityTypeOneCard(bytes32 game_key, AbilityTrigger trigger, bytes32 triggerer) internal {
        bytes32[] memory players = Matches.getPlayers(game_key);
        for (uint i = 0; i < players.length; i++) {
            TriggerCardAbilityTypePlayer(trigger, triggerer, players[i]);

            bytes32[] memory cards = PlayerCardsBoard.getValue(players[i]);
            for (uint j = 0; j < cards.length; j++) {
                TriggerCardAbilityTypeTwoCard(trigger, triggerer, cards[j]);
            }
        }
    }

    function TriggerCardAbilityTypeTwoCard(AbilityTrigger trigger, bytes32 caster, bytes32 triggerer) internal {
        bytes32[] memory abilities = Cards.getAbilities(caster);
        for (uint i = 0; i < abilities.length; i++) {
            if (Ability.getTrigger(abilities[i]) == trigger) {
                //todo
            }

        }

        //todo
    }

    function TriggerCardAbilityTypePlayer(AbilityTrigger trigger, bytes32 card_key, bytes32 player_key) internal {
        //todo
    }

}