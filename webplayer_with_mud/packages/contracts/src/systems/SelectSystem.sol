// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import {System} from "@latticexyz/world/src/System.sol";
import {GamesExtended, CardOnBoards} from "../codegen/index.sol";
import {SelectorType} from "../codegen/common.sol";


contract SelectSystem is System {
    function SelectCard(bytes32 game_uid, bytes32 card_uid) public {
        if (GamesExtended.getSelector(game_uid) == SelectorType.None) {
            return;
        }

        if (GamesExtended.getSelector(game_uid) == SelectorType.SelectTarget) {

        }

        if (GamesExtended.getSelector(game_uid) == SelectorType.SelectorChoice) {

        }
    }

    function SelectPlayer() public {

    }

    function SelectSlot() public {

    }

    function SelectChoice() public {

    }

    function CancelSelection() public {

    }
}