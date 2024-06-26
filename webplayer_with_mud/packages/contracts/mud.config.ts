import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
    enums: {
        SelectorType: ["None", "SelectTarget", "SelectorCard", "SelectorChoice"],
        RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
        PackType: ["FIXED", "RANDOM"],
        TeamType: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        GameType: ["SOLO", "ADVENTURE", "MULTIPLAYER", "HOST_P2P", "OBSERVER"],
        GameMode: ["CASUAL", "RANKED"],
        GameState: ["INIT", "PLAY", "GAME_ENDED"],
        GamePhase: ["NONE", "START_TURN", "MAIN", "END_TURN"],
        CardType: ["None", "Hero", "Character", "Spell", "Artifact", "Secret", "Equipment"],
        CardTeam: ["None", 'Green', 'Red', 'Blue'],
        CardTrait: ["None", "Wolf", "Dragon", "Growth", "SpellDamage"],
        AbilityTrigger: ["NONE", "ONGOING", "ACTIVATE", "ON_PLAY", "ON_PLAY_OTHER", "START_OF_TURN", "END_OF_TURN", "ON_BEFORE_ATTACK", "ON_AFTER_ATTACK", "ON_BEFORE_DEFEND", "ON_AFTER_DEFEND", "ON_KILL", "ON_DEATH", "ON_DEATH_OTHER"],
        AbilityTarget: ["None", "Self", "PlayerSelf", "PlayerOpponent", "AllPlayers", "AllCardsBoard", "AllCardsHand", "AllCardsAllPiles", "AllSlots", "AllCardData", "PlayTarget", "AbilityTriggerer", "EquippedCard", "SelectTarget", "CardSelector", "ChoiceSelector", "LastPlayed", "LastTargeted", "LastDestroyed", "LastSummoned"],
        Team: ["FIRE", "FOREST", "WATER", "NEUTRAL"],
        Action: ["PlayCard", "Attack", "AttackPlayer", "Move", "CastAbility", "SelectCard", "SelectPlayer", "SelectSlot", "SelectChoice", "CancelSelect", "EndTurn", "ChangeMana", 'AddStatus', 'ChangeCard','Dice'],
        PileType: ["None", "Board", "Hand", "Deck", "Discard", "Secret", "Equipped", "Temp"],
        EffectStatType: ["None", "Attack", "HP", "Mana"],
        ConditionObjType: ["ConditionCardType"],
        EffectAttackerType: ["Self", "AbilityTriggerer", "LastPlayed", "LastTargeted"],
        Status: ["None", "Armor", 'Attack', 'Deathtouch', 'Flying', 'Fury', 'Hp', 'Intimidate', 'Invincibility', 'Lifesteal', 'Paralysed', 'Poisoned', 'Protected', 'Shell', 'Silenced', 'Sleep', 'SpellImmunity', 'Stealth', 'Taunt', 'Trample', 'Protection', 'LifeSteal'],
        ConditionStatType: ["None", 'Attack', 'HP', 'Mana'],
        ConditionPlayerType: ['Self', 'Opponent', 'Both'],
        ConditionOperatorInt: ['Equal', 'NotEqual', 'GreaterEqual', 'LessEqual', 'Greater', 'Less'],
        ConditionOperatorBool: ['IsTrue', 'IsFalse'],
        ConditionTargetType: ["None", "Card", "Player", "Slot", "CardData"],
    },
    systems: {
        AbilitySecretsSystem: {
            openAccess: false,
            accessList: [],
            name: "AbilitySecretsSystem",
        },
        AbilitySystem: {
            openAccess: false,
            accessList: [],
            name: "AbilitySystem",
        },
        AbilityTargetSystem: {
            openAccess: false,
            accessList: [],
            name: "AbilityTargetSystem",
        },
        Effect1System: {
            openAccess: false,
            accessList: [],
            name: "Effect1System",
        },
        Effect2System: {
            openAccess: false,
            accessList: [],
            name: "Effect2System",
        },
        Effect3System: {
            openAccess: false,
            accessList: [],
            name: "Effect3System",
        },
        Effect4System: {
            openAccess: false,
            accessList: [],
            name: "Effect4System",
        },
        Effect5System: {
            openAccess: false,
            accessList: [],
            name: "Effect5System",
        },
        Effect6System: {
            openAccess: false,
            accessList: [],
            name: "Effect6System",
        },
        Effect7System: {
            openAccess: false,
            accessList: [],
            name: "Effect7System",
        },
        FilterSystem: {
            openAccess: false,
            accessList: [],
            name: "FilterSystem",
        },
        ConditionSystem: {
            openAccess: false,
            accessList: [],
            name: "ConditionSystem",
        },
        SlotSystem: {
            openAccess: false,
            accessList: [],
            name: "SlotSystem",
        },
        OnGoingSystem: {
            openAccess: false,
            accessList: [],
            name: "OnGoingSystem",
        },
        GmSystem: {
            openAccess: true,
            accessList: [],
            // openAccess: false,
            // accessList: ["0xcF1A02C9836558e8fd04Cff8F072b71D4F03f94e","0x891014E466EF515ECe0C91Ba9d491f5f48b9b2AF"],
            name: "GmSystem",
        },
        ConfigSystem: {
            openAccess: true,
            accessList: [],
            // openAccess: false,
            // accessList: ["0xcF1A02C9836558e8fd04Cff8F072b71D4F03f94e","0x891014E466EF515ECe0C91Ba9d491f5f48b9b2AF"],
            name: "ConfigSystem",
        },
    },
    tables: {
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
            keySchema: {
                key: "address"
            },
            valueSchema: {
                owner: "address",
                coin: "uint256",
                xp: "uint256",
                createdAt: "uint256",
                game: "bytes32",
                cards: "bytes32[]",
                packs: "bytes32[]",
                id: "string",
                decks: "bytes32[]",
            }
        },
        UsersExtended: {
            keySchema: {
                key: "address"
            },
            valueSchema: {
                avatar: "string",
                cardback: "string",
            }
        },
        Config: {
            keySchema: {},
            valueSchema: {
                admin: "bytes32[]",
                cards: "bytes32[]",
                ability: "bytes32[]",
            }
        },
        Cards: {
            valueSchema: {
                mana: "int8",
                attack: "int8",
                hp: "int8",
                cardType: "CardType",
                team: "CardTeam",
                trait: "CardTrait",
                deckbuilding: "bool",
                tid: "string",
                abilities: "bytes32[]",
            },
        },
        CardsExtend: {
            valueSchema: {
                rarity: "RarityType",
                cost: "uint32",
                packs: "bytes32[]",
            }
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
                conditionsTarget: "bytes4[]",
                conditionsTrigger: "bytes4[]",
                filtersTarget: "bytes4[]",
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
                status: "uint32[]",
                ongoingStatus: "uint32[]",
                ability: "bytes32[]",
                trait: "uint16[]",
                name: "string",
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
                turnDuration: "uint256",
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
                abilityTriggerer: "bytes32",
                lastPlayed: "bytes32",
                lastTarget: "bytes32",
                lastDestroyed: "bytes32",
                lastSummoned: "bytes32",
                rolledValue: "int8",
                abilityPlayed: "bytes32[]",
            }
        },
        Matches: {
            keySchema: {
                id: "uint256"
            },
            valueSchema: {
                startTime: "uint256",
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
                dcards: "int8",
                ncards: "uint8",
                game: "bytes32",
                hero: "bytes32",
                name: "string",
                deck: "string",
                status: "uint32[]",
                ongoingStatus: "uint32[]",
                trait: "uint16[]",
            }
        },
        PlayerSlots: {
            valueSchema: {
                a: "bytes32",
                b: "bytes32",
                c: "bytes32",
                d: "bytes32",
                e: "bytes32",
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
                valueU8: "uint8",
                payload: "bytes"
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
