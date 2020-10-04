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

part of 'list_shared_albums_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSharedAlbumsResponse _$ListSharedAlbumsResponseFromJson(
    Map<String, dynamic> json) {
  return ListSharedAlbumsResponse(
      (json['sharedAlbums'] as List)
          ?.map((e) =>
              e == null ? null : Album.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['nextPageToken'] as String);
}

Map<String, dynamic> _$ListSharedAlbumsResponseToJson(
        ListSharedAlbumsResponse instance) =>
    <String, dynamic>{
      'sharedAlbums': instance.sharedAlbums,
      'nextPageToken': instance.nextPageToken
    };
