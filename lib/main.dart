import 'package:archeofind/models/photos_library_api_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'presentation/tabs/pages/tabs_page.dart';

void main() {
    final apiModel = PhotosLibraryApiModel();
    apiModel.signInSilently();
    runApp(
      ScopedModel<PhotosLibraryApiModel>(
        model: apiModel,
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}