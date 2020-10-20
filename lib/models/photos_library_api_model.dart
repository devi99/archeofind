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
import 'dart:io';

import 'package:archeofind/photos_library_api/batch_create_media_items_request.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:archeofind/photos_library_api/batch_create_media_items_response.dart';
import 'package:archeofind/photos_library_api/photos_library_api_client.dart';

class PhotosLibraryApiModel extends Model {
  PhotosLibraryApiModel() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;

      if (_currentUser != null) {
        // Initialize the client with the new user credentials
        client = PhotosLibraryApiClient(_currentUser.authHeaders);
      } else {
        // Reset the client
        client = null;
      }

      notifyListeners();
    });
  }

  PhotosLibraryApiClient client;

  GoogleSignInAccount _currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
    'profile',
    'https://www.googleapis.com/auth/photoslibrary',
    'https://www.googleapis.com/auth/photoslibrary.sharing'
  ]);
  GoogleSignInAccount get user => _currentUser;

  bool isLoggedIn() {
    return _currentUser != null;
  }

  Future<bool> signIn() async {
    final GoogleSignInAccount user = await _googleSignIn.signIn();

    if (user == null) {
      // User could not be signed in
      print('User could not be signed in.');
      return false;
    }

    print('User signed in.');
    return true;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }

  Future<void> signInSilently() async {
    final GoogleSignInAccount user = await _googleSignIn.signInSilently();
    //if (_currentUser == null) {
    if (user == null) {
      // User could not be signed in
      return;
    }
    print('User signed in silently.');
  }

  Future<String> uploadMediaItem(File image) {
    return client.uploadMediaItem(image);
  }

  Future<BatchCreateMediaItemsResponse> createMediaItem(
      String uploadToken, String albumId, String description) {
  // Construct the request with the token, albumId and description.
    final BatchCreateMediaItemsRequest request =
        BatchCreateMediaItemsRequest.inAlbum(uploadToken, albumId, description);

    // Make the API call to create the media item. The response contains a
    // media item.
    return client
        .batchCreateMediaItems(request)
        .then((BatchCreateMediaItemsResponse response) {
      // Print and return the response.
      print(response.newMediaItemResults[0].toJson());
      return response;
    });
  }

}
