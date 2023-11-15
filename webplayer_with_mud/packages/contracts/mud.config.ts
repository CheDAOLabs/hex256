import {mudConfig} from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    RarityType: ["COMMON", "UNCOMMON", "RARE", "MYTHIC"],
    PackType: ["Fixed", "Random"]
  },
  tables: {
    CounterSingleton: {
      keySchema: {},
      valueSchema: "uint256",
    },
    CardCommonSingleton: {
      keySchema: {},
      valueSchema: "bytes32[]",
    },
    Packs: {
      valueSchema: {
        packType:"PackType",
        id: "string",
        cards: "uint256[]",
      }
    },
    Users: {
      valueSchema: {
        owner: "address",
        coin: "uint256",
        xp: "uint256",
        createdAt: "uint256",
        cards: "bytes32[]",
        packs: "uint256[]",
        id: "string",
        avatar: "string",
        cardback: "string",
      }
    },
    Cards: {
      valueSchema: {
        rarity: "RarityType",
        mana: "uint8",
        attack: "uint8",
        hp: "uint8",
        cost: "uint32",
        tid: "string",
        cardType: "string",
        team: "string",
      },
    },
    Tasks: {
      valueSchema: {
        createdAt: "uint256",
        completedAt: "uint256",
        description: "string",
      },
    },
  },
});
