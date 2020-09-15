import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{

  static Database _database;

  Future<Database> get database async {
      if (_database != null) return _database;
      _database = await getDatabaseInstance();
      return _database;
    }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "archeofinds_1.db");
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE ImageFinds ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "type INTEGER,"
          "project TEXT,"
          "date INTEGER,"
          "uploaded INTEGER,"
          "purpose INTEGER,"
          "windDirection TEXT,"
          "werkput TEXT,"
          "vlak TEXT,"
          "spoor TEXT,"
          "coupe TEXT,"
          "profiel TEXT,"
          "structuur TEXT,"
          "vondst TEXT"
          ");");
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion == 2){
            db.execute("ALTER TABLE ImageFinds ADD COLUMN uploaded INTEGER;");
          }
        }
    );
  }
}