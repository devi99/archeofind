import 'package:archeofind/presentation/defaults/pages/defaultsDetail.dart';
import 'package:archeofind/presentation/sync/pages/syncedImagesList.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/presentation/home/pages/home_page.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomePage(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        TabNavigationItem(
          page: DefaultsDetail(),
          icon: Icon(Icons.text_fields),
          title: Text("Defaults"),
        ),
        TabNavigationItem(
          page: SyncedImagesList(),
          icon: Icon(Icons.sync),
          title: Text("Sync"),
        ),
      ];
}
