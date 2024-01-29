// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

/**
 * @title IEffectSystem
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface IEffectSystem {
  function DoEffect(bytes4 effect, bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectAddAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectAddGrowth(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectAddHP(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectAddMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectAddSpellDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectChangeOwnerSelf(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectClearParalyse(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectClearTaunt(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectClearStatusAll(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectDamage(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectDestroyEquip(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectDestroy(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectDiscard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectDraw(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectGainMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectHeal(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectPlayCard(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectRemoveAbilityAuraHelp(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectResetStats(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectRollD6(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectSetAttack(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectSetHP(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectSetMana(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectExhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;

  function EffectUnexhaust(bytes32 ability_key, bytes32 caster, bytes32 target, bool is_card) external;
}