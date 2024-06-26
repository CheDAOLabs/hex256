// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {FunctionSelectors} from "@latticexyz/world/src/codegen/tables/FunctionSelectors.sol";
import {ResourceId} from "@latticexyz/world/src/WorldResourceId.sol";
import {Cards, CardsExtend} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, Ability, AbilityExtend} from "../codegen/index.sol";
import {Config} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, AbilityTarget, CardTrait} from "../codegen/common.sol";
import {CardRaritySingleton} from "../codegen/index.sol";

contract ConfigSystem is System {


    constructor() {
    }

    function initCard(string memory name, int8 mana, int8 attack, int8 hp, uint32 cost, bytes32[] memory abilities, CardType cardType, RarityType rarity, bool is_deckbuilding, CardTrait trait) public returns (bytes32 key)  {
        key = keccak256(abi.encode(name));
        Cards.setMana(key, mana);
        Cards.setAttack(key, attack);
        Cards.setHp(key, hp);
        Cards.setTid(key, name);
        Cards.setCardType(key, cardType);
//        Cards.setTeam(key, "1");
        Cards.setAbilities(key, abilities);
        Cards.setDeckbuilding(key, is_deckbuilding);
        Cards.setTrait(key, trait);

        CardsExtend.setCost(key, cost);
        CardsExtend.setRarity(key, rarity);


        if (rarity == RarityType.COMMON) {
            CardRaritySingleton.pushCommon(key);
        }

        if (rarity == RarityType.UNCOMMON) {
            CardRaritySingleton.pushUncommon(key);
        }

        if (rarity == RarityType.RARE) {
            CardRaritySingleton.pushRare(key);
        }

        if (rarity == RarityType.MYTHIC) {
            CardRaritySingleton.pushMythic(key);
        }

        Config.pushCards(key);

    }

//    function getCard(string memory id) public view returns (CardsData memory _table) {
//        bytes32 key = keccak256(abi.encode(id));
//        return Cards.get(key);
//    }
//
//    function setCard(string memory id, CardsData calldata data) public {
//        bytes32 key = keccak256(abi.encode(id));
//        Cards.set(key, data);
//    }


    function initPack(string memory name, PackType _packType, uint8 _cards, uint8[] memory _rarities, uint32 _cost) public returns (bytes32 key) {
        key = keccak256(abi.encode(name));
        Packs.set(key, PacksData({packType: _packType, cards: _cards, id: name, rarities: _rarities, cost: _cost}));
    }

    function initDeck(string memory name, bytes32 hero, bytes32[] memory _cards) public returns (bytes32 key) {
        key = keccak256(abi.encode(name));
        Decks.setTid(key, name);
        Decks.setHero(key, hero);
        Decks.setCards(key, _cards);
    }

    function revertWithStringAndBytes4(string memory str, bytes4 errorData) internal pure {
        bytes memory strBytes = bytes(str);
        bytes memory errorMsg = abi.encodePacked(strBytes, errorData);
        revert(string(errorMsg));
    }

    function initAbilityExtend(
        string memory id,
        bytes4[] memory conditionsTarget,
        bytes4[] memory conditionsTrigger,
        bytes4[] memory filtersTarget,
        bytes32[] memory chainAbilities
    ) public returns (bytes32 key)
    {

        key = keccak256(abi.encode(id));

        for (uint i = 0; i < conditionsTrigger.length; i++) {
            if (!isSelectorExist(conditionsTrigger[i])) {
                revertWithStringAndBytes4("Condition trigger not exist", conditionsTrigger[i]);
            }
        }

        for (uint i = 0; i < conditionsTarget.length; i++) {
            if (!isSelectorExist(conditionsTarget[i])) {
                revertWithStringAndBytes4("Condition target not exist", conditionsTarget[i]);
            }
        }

        for (uint i = 0; i < filtersTarget.length; i++) {
            if (!isSelectorExist(filtersTarget[i])) {
                revert("Filter not exist");
            }
        }

        AbilityExtend.setConditionsTarget(key, conditionsTarget);
        AbilityExtend.setConditionsTrigger(key, conditionsTrigger);
        AbilityExtend.setFiltersTarget(key, filtersTarget);
        AbilityExtend.setChainAbilities(key, chainAbilities);

    }

    function initAbility(
        string memory id,
        AbilityTrigger trigger,
        AbilityTarget target,
        int8 value,
        uint8 manaCost,
        uint8 duration,
        bool exhaust,
        bytes4[] memory effects,
        uint8[] memory status
    ) public returns (bytes32 key)
    {
        for (uint i = 0; i < effects.length; i++) {
            if (!isSelectorExist(effects[i])) {
                revert("Effect not exist");
            }
        }

        key = keccak256(abi.encode(id));
        Ability.setId(key, id);
        Ability.setValue(key, value);
        Ability.setManaCost(key, manaCost);
        Ability.setDuration(key, duration);
        Ability.setExhaust(key, exhaust);
        Ability.setEffects(key, effects);
        Ability.setTrigger(key, trigger);
        Ability.setTarget(key, target);
        Ability.setStatus(key, status);
        Config.pushAbility(key);
    }

    function isSelectorExist(bytes4 selector) internal view returns (bool) {
        (ResourceId systemId, bytes4 systemFunctionSelector) = FunctionSelectors.get(selector);
        if (ResourceId.unwrap(systemId) == 0) {
            return false;
        }
        return true;
    }


}
