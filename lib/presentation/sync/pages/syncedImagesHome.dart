import 'package:archeofind/models/photos_library_api_model.dart';
import 'package:archeofind/presentation/sync/pages/syncedImagesList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_page.dart';

class SyncedImagesHome extends StatelessWidget {
      static Route<dynamic> route() => MaterialPageRoute(
      builder: (context) => SyncedImagesHome(),
    );
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhotosLibraryApiModel>(
      builder: (context, child, apiModel) {
        return apiModel.isLoggedIn() ? SyncedImagesList() : LoginPage();
      },
    );
  }
}
