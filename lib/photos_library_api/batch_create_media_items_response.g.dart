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

part of 'batch_create_media_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchCreateMediaItemsResponse _$BatchCreateMediaItemsResponseFromJson(
    Map<String, dynamic> json) {
  return BatchCreateMediaItemsResponse((json['newMediaItemResults'] as List)
      ?.map((e) => e == null
          ? null
          : NewMediaItemResult.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$BatchCreateMediaItemsResponseToJson(
        BatchCreateMediaItemsResponse instance) =>
    <String, dynamic>{'newMediaItemResults': instance.newMediaItemResults};

NewMediaItemResult _$NewMediaItemResultFromJson(Map<String, dynamic> json) {
  return NewMediaItemResult(
      json['uploadToken'] as String,
      json['mediaItem'] == null
          ? null
          : MediaItem.fromJson(json['mediaItem'] as Map<String, dynamic>));
}

Map<String, dynamic> _$NewMediaItemResultToJson(NewMediaItemResult instance) =>
    <String, dynamic>{
      'uploadToken': instance.uploadToken,
      'mediaItem': instance.mediaItem
    };
