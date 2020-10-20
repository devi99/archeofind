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

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:archeofind/photos_library_api/batch_create_media_items_request.dart';
import 'package:archeofind/photos_library_api/batch_create_media_items_response.dart';
import 'package:path/path.dart';
//import 'package:path/path.dart' as path;

class PhotosLibraryApiClient {
  PhotosLibraryApiClient(this._authHeaders);

  Future<Map<String, String>> _authHeaders;

  Future<String> uploadMediaItem(File image) async {
    // Get the filename of the image
    final String filename = basename(image.path);
    // Set up the headers required for this request.
    final Map<String, String> headers = <String,String>{};
    headers.addAll(await _authHeaders);
    headers['Content-type'] = 'application/octet-stream';
    headers['X-Goog-Upload-Protocol'] = 'raw';
    headers['X-Goog-Upload-File-Name'] = filename;
    // Make the HTTP request to upload the image. The file is sent in the body.
    return http
        .post(
      'https://photoslibrary.googleapis.com/v1/uploads',
      body: image.readAsBytesSync(),
      headers: await _authHeaders,
    )
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }
      return response.body;
    });
  }

  Future<BatchCreateMediaItemsResponse> batchCreateMediaItems(
      BatchCreateMediaItemsRequest request) async {
    print(request.toJson());
    print(await _authHeaders);
    return http
        .post('https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate',
            body: jsonEncode(request), headers: await _authHeaders)
        .then((Response response) {
      if (response.statusCode != 200) {
        print(response.reasonPhrase);
        print(response.body);
      }

      return BatchCreateMediaItemsResponse.fromJson(jsonDecode(response.body));
    });
  }
}
