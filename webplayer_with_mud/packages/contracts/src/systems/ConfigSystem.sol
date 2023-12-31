// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {Cards, CardsData} from "../codegen/index.sol";
import {Packs, PacksData} from "../codegen/index.sol";
import {Decks, Ability} from "../codegen/index.sol";
import {CardType, GameType, GameState, GamePhase, PackType, RarityType, AbilityTrigger, AbilityTarget} from "../codegen/common.sol";
import {CardRaritySingleton} from "../codegen/index.sol";

contract ConfigSystem is System {

    function initCard(string memory name, uint8 mana, uint8 attack, uint8 hp, uint32 cost, bytes32[] memory abilities, CardType cardType, RarityType rarity) public returns (bytes32 key)  {
        key = keccak256(abi.encode(name));
        Cards.setMana(key, mana);
        Cards.setAttack(key, attack);
        Cards.setHp(key, hp);
        Cards.setCost(key, cost);
        Cards.setTid(key, name);
        Cards.setCardType(key, cardType);
        Cards.setTeam(key, "1");
        Cards.setRarity(key, rarity);
        Cards.setAbilities(key, abilities);


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

    }

    function getCard(string memory id) public view returns (CardsData memory _table) {
        bytes32 key = keccak256(abi.encode(id));
        return Cards.get(key);
    }

    function setCard(string memory id, CardsData calldata data) public {
        bytes32 key = keccak256(abi.encode(id));
        Cards.set(key, data);
    }

    function initPack(string memory name, PackType _packType, uint8 _cards, uint8[] memory _rarities, uint32 _cost) public returns (bytes32 key) {
        key = keccak256(abi.encode(name));
        Packs.set(key, PacksData({packType : _packType, cards : _cards, id : name, rarities : _rarities, cost : _cost}));
    }

    function initDeck(string memory name, bytes32 hero, bytes32[] memory _cards) public returns (bytes32 key) {
        key = keccak256(abi.encode(name));
        Decks.setTid(key, name);
        Decks.setHero(key, hero);
        Decks.setCards(key, _cards);
    }

    function initAbility(string memory id, AbilityTrigger trigger, AbilityTarget target, uint8 value, uint8 manaCost, uint8 duration, bool exhaust, bytes4[] memory effects) public returns (bytes32 key){
        key = keccak256(abi.encode(id));
        Ability.setId(key, id);
        Ability.setValue(key, value);
        Ability.setManaCost(key, manaCost);
        Ability.setDuration(key, duration);
        Ability.setExhaust(key, exhaust);
        Ability.setEffects(key, effects);
        Ability.setTrigger(key, trigger);
        Ability.setTarget(key, target);
    }


}
