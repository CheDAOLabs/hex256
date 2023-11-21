// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout, FieldLayoutLib } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";
import { RESOURCE_TABLE, RESOURCE_OFFCHAIN_TABLE } from "@latticexyz/store/src/storeResourceTypes.sol";

ResourceId constant _tableId = ResourceId.wrap(
  bytes32(abi.encodePacked(RESOURCE_TABLE, bytes14(""), bytes16("CardRaritySingle")))
);
ResourceId constant CardRaritySingletonTableId = _tableId;

FieldLayout constant _fieldLayout = FieldLayout.wrap(
  0x0000000400000000000000000000000000000000000000000000000000000000
);

struct CardRaritySingletonData {
  bytes32[] common;
  bytes32[] uncommon;
  bytes32[] rare;
  bytes32[] mythic;
}

library CardRaritySingleton {
  /**
   * @notice Get the table values' field layout.
   * @return _fieldLayout The field layout for the table.
   */
  function getFieldLayout() internal pure returns (FieldLayout) {
    return _fieldLayout;
  }

  /**
   * @notice Get the table's key schema.
   * @return _keySchema The key schema for the table.
   */
  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _keySchema = new SchemaType[](0);

    return SchemaLib.encode(_keySchema);
  }

  /**
   * @notice Get the table's value schema.
   * @return _valueSchema The value schema for the table.
   */
  function getValueSchema() internal pure returns (Schema) {
    SchemaType[] memory _valueSchema = new SchemaType[](4);
    _valueSchema[0] = SchemaType.BYTES32_ARRAY;
    _valueSchema[1] = SchemaType.BYTES32_ARRAY;
    _valueSchema[2] = SchemaType.BYTES32_ARRAY;
    _valueSchema[3] = SchemaType.BYTES32_ARRAY;

    return SchemaLib.encode(_valueSchema);
  }

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](0);
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](4);
    fieldNames[0] = "common";
    fieldNames[1] = "uncommon";
    fieldNames[2] = "rare";
    fieldNames[3] = "mythic";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, getKeySchema(), getValueSchema(), getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get common.
   */
  function getCommon() internal view returns (bytes32[] memory common) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get common.
   */
  function _getCommon() internal view returns (bytes32[] memory common) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set common.
   */
  function setCommon(bytes32[] memory common) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((common)));
  }

  /**
   * @notice Set common.
   */
  function _setCommon(bytes32[] memory common) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((common)));
  }

  /**
   * @notice Get the length of common.
   */
  function lengthCommon() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of common.
   */
  function _lengthCommon() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of common.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemCommon(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of common.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemCommon(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to common.
   */
  function pushCommon(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to common.
   */
  function _pushCommon(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from common.
   */
  function popCommon() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 32);
  }

  /**
   * @notice Pop an element from common.
   */
  function _popCommon() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 32);
  }

  /**
   * @notice Update an element of common at `_index`.
   */
  function updateCommon(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of common at `_index`.
   */
  function _updateCommon(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get uncommon.
   */
  function getUncommon() internal view returns (bytes32[] memory uncommon) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get uncommon.
   */
  function _getUncommon() internal view returns (bytes32[] memory uncommon) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set uncommon.
   */
  function setUncommon(bytes32[] memory uncommon) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((uncommon)));
  }

  /**
   * @notice Set uncommon.
   */
  function _setUncommon(bytes32[] memory uncommon) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((uncommon)));
  }

  /**
   * @notice Get the length of uncommon.
   */
  function lengthUncommon() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of uncommon.
   */
  function _lengthUncommon() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of uncommon.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemUncommon(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of uncommon.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemUncommon(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to uncommon.
   */
  function pushUncommon(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to uncommon.
   */
  function _pushUncommon(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from uncommon.
   */
  function popUncommon() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Pop an element from uncommon.
   */
  function _popUncommon() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Update an element of uncommon at `_index`.
   */
  function updateUncommon(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of uncommon at `_index`.
   */
  function _updateUncommon(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get rare.
   */
  function getRare() internal view returns (bytes32[] memory rare) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 2);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get rare.
   */
  function _getRare() internal view returns (bytes32[] memory rare) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 2);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set rare.
   */
  function setRare(bytes32[] memory rare) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 2, EncodeArray.encode((rare)));
  }

  /**
   * @notice Set rare.
   */
  function _setRare(bytes32[] memory rare) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setDynamicField(_tableId, _keyTuple, 2, EncodeArray.encode((rare)));
  }

  /**
   * @notice Get the length of rare.
   */
  function lengthRare() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 2);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of rare.
   */
  function _lengthRare() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 2);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of rare.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemRare(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 2, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of rare.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemRare(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 2, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to rare.
   */
  function pushRare(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to rare.
   */
  function _pushRare(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from rare.
   */
  function popRare() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 2, 32);
  }

  /**
   * @notice Pop an element from rare.
   */
  function _popRare() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 2, 32);
  }

  /**
   * @notice Update an element of rare at `_index`.
   */
  function updateRare(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 2, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of rare at `_index`.
   */
  function _updateRare(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 2, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get mythic.
   */
  function getMythic() internal view returns (bytes32[] memory mythic) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 3);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get mythic.
   */
  function _getMythic() internal view returns (bytes32[] memory mythic) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 3);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set mythic.
   */
  function setMythic(bytes32[] memory mythic) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 3, EncodeArray.encode((mythic)));
  }

  /**
   * @notice Set mythic.
   */
  function _setMythic(bytes32[] memory mythic) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setDynamicField(_tableId, _keyTuple, 3, EncodeArray.encode((mythic)));
  }

  /**
   * @notice Get the length of mythic.
   */
  function lengthMythic() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 3);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of mythic.
   */
  function _lengthMythic() internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 3);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of mythic.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemMythic(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 3, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of mythic.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemMythic(uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 3, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to mythic.
   */
  function pushMythic(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 3, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to mythic.
   */
  function _pushMythic(bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 3, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from mythic.
   */
  function popMythic() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 3, 32);
  }

  /**
   * @notice Pop an element from mythic.
   */
  function _popMythic() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 3, 32);
  }

  /**
   * @notice Update an element of mythic at `_index`.
   */
  function updateMythic(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 3, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of mythic at `_index`.
   */
  function _updateMythic(uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 3, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get() internal view returns (CardRaritySingletonData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get() internal view returns (CardRaritySingletonData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    (bytes memory _staticData, PackedCounter _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    bytes32[] memory common,
    bytes32[] memory uncommon,
    bytes32[] memory rare,
    bytes32[] memory mythic
  ) internal {
    bytes memory _staticData;
    PackedCounter _encodedLengths = encodeLengths(common, uncommon, rare, mythic);
    bytes memory _dynamicData = encodeDynamic(common, uncommon, rare, mythic);

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes32[] memory common,
    bytes32[] memory uncommon,
    bytes32[] memory rare,
    bytes32[] memory mythic
  ) internal {
    bytes memory _staticData;
    PackedCounter _encodedLengths = encodeLengths(common, uncommon, rare, mythic);
    bytes memory _dynamicData = encodeDynamic(common, uncommon, rare, mythic);

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(CardRaritySingletonData memory _table) internal {
    bytes memory _staticData;
    PackedCounter _encodedLengths = encodeLengths(_table.common, _table.uncommon, _table.rare, _table.mythic);
    bytes memory _dynamicData = encodeDynamic(_table.common, _table.uncommon, _table.rare, _table.mythic);

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(CardRaritySingletonData memory _table) internal {
    bytes memory _staticData;
    PackedCounter _encodedLengths = encodeLengths(_table.common, _table.uncommon, _table.rare, _table.mythic);
    bytes memory _dynamicData = encodeDynamic(_table.common, _table.uncommon, _table.rare, _table.mythic);

    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    PackedCounter _encodedLengths,
    bytes memory _blob
  )
    internal
    pure
    returns (bytes32[] memory common, bytes32[] memory uncommon, bytes32[] memory rare, bytes32[] memory mythic)
  {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    common = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    uncommon = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(2);
    }
    rare = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(3);
    }
    mythic = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   *
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory,
    PackedCounter _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (CardRaritySingletonData memory _table) {
    (_table.common, _table.uncommon, _table.rare, _table.mythic) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord() internal {
    bytes32[] memory _keyTuple = new bytes32[](0);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    bytes32[] memory common,
    bytes32[] memory uncommon,
    bytes32[] memory rare,
    bytes32[] memory mythic
  ) internal pure returns (PackedCounter _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = PackedCounterLib.pack(
        common.length * 32,
        uncommon.length * 32,
        rare.length * 32,
        mythic.length * 32
      );
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(
    bytes32[] memory common,
    bytes32[] memory uncommon,
    bytes32[] memory rare,
    bytes32[] memory mythic
  ) internal pure returns (bytes memory) {
    return
      abi.encodePacked(
        EncodeArray.encode((common)),
        EncodeArray.encode((uncommon)),
        EncodeArray.encode((rare)),
        EncodeArray.encode((mythic))
      );
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dyanmic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    bytes32[] memory common,
    bytes32[] memory uncommon,
    bytes32[] memory rare,
    bytes32[] memory mythic
  ) internal pure returns (bytes memory, PackedCounter, bytes memory) {
    bytes memory _staticData;
    PackedCounter _encodedLengths = encodeLengths(common, uncommon, rare, mythic);
    bytes memory _dynamicData = encodeDynamic(common, uncommon, rare, mythic);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple() internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](0);

    return _keyTuple;
  }
}