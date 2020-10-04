/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_create_media_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchCreateMediaItemsRequest _$BatchCreateMediaItemsRequestFromJson(
    Map<String, dynamic> json) {
  return BatchCreateMediaItemsRequest(
      json['albumId'] as String,
      (json['newMediaItems'] as List)
          ?.map((e) => e == null
              ? null
              : NewMediaItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['albumPosition'] == null
          ? null
          : AlbumPosition.fromJson(
              json['albumPosition'] as Map<String, dynamic>));
}

Map<String, dynamic> _$BatchCreateMediaItemsRequestToJson(
        BatchCreateMediaItemsRequest instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'newMediaItems': instance.newMediaItems,
      'albumPosition': instance.albumPosition
    };

NewMediaItem _$NewMediaItemFromJson(Map<String, dynamic> json) {
  return NewMediaItem(
      json['description'] as String,
      json['simpleMediaItem'] == null
          ? null
          : SimpleMediaItem.fromJson(
              json['simpleMediaItem'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NewMediaItemToJson(NewMediaItem instance) =>
    <String, dynamic>{
      'description': instance.description,
      'simpleMediaItem': instance.simpleMediaItem
    };

SimpleMediaItem _$SimpleMediaItemFromJson(Map<String, dynamic> json) {
  return SimpleMediaItem(json['uploadToken'] as String);
}

Map<String, dynamic> _$SimpleMediaItemToJson(SimpleMediaItem instance) =>
    <String, dynamic>{'uploadToken': instance.uploadToken};

AlbumPosition _$AlbumPositionFromJson(Map<String, dynamic> json) {
  return AlbumPosition(
      json['relativeMediaItemId'] as String,
      json['relativeEnrichmentItemId'] as String,
      _$enumDecodeNullable(_$PositionTypeEnumMap, json['position']));
}

Map<String, dynamic> _$AlbumPositionToJson(AlbumPosition instance) =>
    <String, dynamic>{
      'relativeMediaItemId': instance.relativeMediaItemId,
      'relativeEnrichmentItemId': instance.relativeEnrichmentItemId,
      'position': _$PositionTypeEnumMap[instance.position]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$PositionTypeEnumMap = <PositionType, dynamic>{
  PositionType.POSITION_TYPE_UNSPECIFIED: 'POSITION_TYPE_UNSPECIFIED',
  PositionType.FIRST_IN_ALBUM: 'FIRST_IN_ALBUM',
  PositionType.LAST_IN_ALBUM: 'LAST_IN_ALBUM',
  PositionType.AFTER_MEDIA_ITEM: 'AFTER_MEDIA_ITEM',
  PositionType.AFTER_ENRICHMENT_ITEM: 'AFTER_ENRICHMENT_ITEM'
};
