import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
    enums: {
        SelectorType: ["NONE", "SELECT_TARGET", "SELECTOR_CARD", "SELECTOR_CHOICE"],
        Status: ["NONE", "Silenced", "ATTACK_BONUS", "HP_BONUS", "STEALTH", "INVINCIBILITY", "SHELL", "PROTECTION", "PROTECTED", "ARMOR", "SPELL_IMMUNITY", "DEATHTOUCH", "FURY", "INTIMIDATE", "FLYING", "TRAMPLE", "LIFE_STEAL", "SILENCED", "PARALYSED", "POISONED", "SLEEP"],
        RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
        PackType: ["FIXED", "RANDOM"],
        TeamType: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        GameType: ["SOLO", "ADVENTURE", "MULTIPLAYER", "HOST_P2P", "OBSERVER"],
        GameMode: ["CASUAL", "RANKED"],
        GameState: ["INIT", "PLAY", "GAME_ENDED"],
        GamePhase: ["NONE", "START_TURN", "MAIN", "END_TURN"],
        CardType: ["NONE", "HERO", "CHARACTER", "SPELL", "ARTIFACT", "SECRET", "EQUIPMENT"],
        AbilityTrigger: ["NONE", "ONGOING", "ACTIVATE", "ON_PLAY", "ON_PLAY_OTHER", "START_OF_TURN", "END_OF_TURN", "ON_BEFORE_ATTACK", "ON_AFTER_ATTACK", "ON_BEFORE_DEFEND", "ON_AFTER_DEFEND", "ON_KILL", "ON_DEATH", "ON_DEATH_OTHER"],
        AbilityTarget: ["NONE", "SELF", "PLAYER_SELF", "PLAYER_OPPONENT", "ALL_PLAYERS", "ALL_CARDS_BOARD", "ALL_CARDS_HAND", "ALL_CARDS_ALL_PILES", "ALL_SLOTS", "ALL_CARD_DATA", "PLAY_TARGET", "ABILITY_TRIGGERER", "EQUIPPED_CARD", "SELECT_TARGET", "CARD_SELECTOR", "CHOICE_SELECTOR", "LAST_PLAYED", "LAST_TARGETED", "LAST_DESTROYED", "LAST_SUMMONED"],
        Team: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        Action: ["PlayCard", "Attack", "AttackPlayer", "Move", "CastAbility", "SelectCard", "SelectPlayer", "SelectSlot", "SelectChoice", "CancelSelect", "EndTurn", "ChangeMana"],
        PileType: ["None", "Board", "Hand", "Deck", "Discard", "Secret", "Equipped", "Temp"],
        EffectStatType: ["None", "Attack", "HP", "Mana"],
        ConditionObjType: ["ConditionCardType"],
        TraitData: ["Dragon", "Growth", "SpellDamage", "Wolf"],
        EffectAttackerType: ["Self", "AbilityTriggerer", "LastPlayed", "LastTargeted"],
        // Effect: [
        //     "AddAbilityActivateBurst",
        //     "AddAbilityDefendDiscard",
        //     "AddAbilityPlaySacrifice",
        //     "AddAbilitySufferDamage",
        //     "AddAttackRoll",
        //     "AddAttack",
        //     "AddGrowth",
        //     "AddHP",
        //     "AddMana",
        //     "AddSpellDamage",
        //     "AttackRedirect",
        //     "Attack",
        //     "ChangeOwnerSelf",
        //     "ClearParalyse",
        //     "ClearStatusAll",
        //     "ClearTaunt",
        //     "ClearTemp",
        //     "CreateTemp",
        //     "Damage",
        //     "DestroyEquip",
        //     "Destroy",
        //     "Discard",
        //     "Draw",
        //     "Exhaust",
        //     "GainMana",
        //     "Heal",
        //     "PlayCard",
        //     "RemoveAbilityAuraHelp",
        //     "ResetStats",
        //     "RollD6",
        //     "SendDeck",
        //     "SendHand",
        //     "SetAttack",
        //     "SetHP",
        //     "SetMana",
        //     "ShuffleDeck",
        //     "SummonEagle",
        //     "SummonEgg",
        //     "SummonWolf",
        //     "TransformFish",
        //     "TransformPhoenix",
        //     "Unexhaust",
        // ],
    },
    tables: {
        AdminSingleton: {
            keySchema: {},
            valueSchema: "address",
        },
        CounterSingleton: {
            keySchema: {},
            valueSchema: "uint256",
        },
        MatchingSingleton: {
            keySchema: {},
            valueSchema: "uint256",
        },
        CardRaritySingleton: {
            keySchema: {},
            valueSchema: {
                common: "bytes32[]",
                uncommon: "bytes32[]",
                rare: "bytes32[]",
                mythic: "bytes32[]",
            }
        },
        AiActions: {
            valueSchema: {
                card_uid: "bytes32",
                target_uid: "bytes32",
                target_player_id: "uint8",
                slot: "uint16",
                value: "uint16",
                score: "uint16",
                sort: "uint16",
                valid: "bool"
            },
        },
        Packs: {
            valueSchema: {
                packType: "PackType",
                cards: "uint8",
                cost: "uint32",
                id: "string",
                rarities: "uint8[]",
            }
        },
        Users: {
            valueSchema: {
                owner: "address",
                coin: "uint256",
                xp: "uint256",
                createdAt: "uint256",
                cards: "bytes32[]",
                packs: "bytes32[]",
                id: "string",
                decks: "bytes32[]",
            }
        },
        UsersExtended: {
            valueSchema: {
                avatar: "string",
                cardback: "string",
            }
        },
        Cards: {
            valueSchema: {
                rarity: "RarityType",
                mana: "int8",
                attack: "int8",
                hp: "int8",
                cost: "uint32",
                cardType: "CardType",
                tid: "string",
                team: "string",
                abilities: "bytes32[]",
            },
        },
        Ability: {
            valueSchema: {
                trigger: "AbilityTrigger",
                target: "AbilityTarget",
                value: "int8",
                manaCost: "uint8",
                duration: "uint8",
                exhaust: "bool",
                id: "string",
                effects: "bytes4[]",
                status: "uint8[]",
            },
        },
        AbilityExtend: {
            valueSchema: {
                conditionsTrigger: "bytes32[]",
                filtersTarget: "bytes32[]",
                chainAbilities: "bytes32[]",
            },
        },
        CardOnBoards: {
            valueSchema: {
                slot: "uint16",
                hp: "int8",
                hpOngoing: "int8",
                attack: "int8",
                attackOngoing: "int8",
                mana: "int8",
                manaOngoing: "int8",
                damage: "int8",
                exhausted: "bool",
                equippedUid: "bytes32",
                id: "bytes32",
                playerId: "bytes32",
                status: "uint8[]",
                ability: "bytes32[]",
                trait: "uint8[]"
            }
        },
        Decks: {
            valueSchema: {
                owner: "address",
                hero: "bytes32",
                tid: "string",
                cards: "bytes32[]",
            }
        },
        Games: {
            valueSchema: {
                gameType: "GameType",
                gameState: "GameState",
                gamePhase: "GamePhase",
                firstPlayer: "bytes32",
                currentPlayer: "bytes32",
                turnCount: "uint8",
                nbPlayer: "uint8",
                level: "string",
                uid: "string",
                players: "bytes32[]",
            }
        },
        GamesExtended: {
            valueSchema: {
                selector: "SelectorType",
                selectorPlayerId: "bytes32",
                selectorCasterUid: "bytes32",
                selectorAbility: "bytes32",
                lastPlayed: "bytes32",
                lastTarget: "bytes32",
                lastDestroyed: "bytes32",
            }
        },
        Matches: {
            valueSchema: {
                startTime: "uint256",
                game: "uint256",
                nbPlayers: "uint8",
                players: "address[]",
            }
        },
        Players: {
            valueSchema: {
                owner: "address",
                hp: "int8",
                mana: "int8",
                hpMax: "int8",
                manaMax: "int8",
                isAI: "bool",
                dcards: "uint8",
                game: "bytes32",
                name: "string",
                deck: "string",
                status: "uint8[]",
            }
        },
        PlayerCardsDeck: "bytes32[]",
        PlayerCardsHand: "bytes32[]",
        PlayerCardsBoard: "bytes32[]",
        PlayerCardsEquip: "bytes32[]",
        PlayerCardsDiscard: "bytes32[]",
        PlayerCardsSecret: "bytes32[]",
        PlayerCardsTemp: "bytes32[]",
        PlayerActionHistory: "bytes32[]",
        ActionHistory: {
            valueSchema: {
                actionType: "Action",
                cardId: "bytes32",
                target: "bytes32",
                slot: "uint16",
                playerId: "uint8",
                value: "int8",
            }
        },
        Tasks: {
            valueSchema: {
                createdAt: "uint256",
                completedAt: "uint256",
                description: "string",
            },
        },
        AttackResult: {
            valueSchema: {
                attacker_hp: "uint8",
                target_hp: "uint8",
            }
        },
        Condition: {
            valueSchema: {
                objType: "ConditionObjType",
                name: "string",
            }
        },
        ConditionCardType: {
            valueSchema: {
                name: "string",
                hasTeam: "string",
                hasTrait: "string",
                hasType: "string"
            }
        },
    },
});
