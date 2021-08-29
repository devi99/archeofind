
import 'package:archeofind/models/imageFind.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:archeofind/services/database.dart';

class DatabaseImageFindHelper
{

  static Database db;  
  String currentTable = 'ImageFinds';
  DatabaseProvider dbProvider=DatabaseProvider();

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getImageFindMapList(int uploaded) async {
    Database db = await dbProvider.database;
    try {
      var result = await db.query(currentTable,where: 'uploaded = $uploaded' , orderBy: 'id ASC');
      return result;
    } catch (e) {
      await db.execute("CREATE TABLE ImageFinds ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "type INTEGER,"
          "project TEXT,"
          "date INTEGER"
          "uploaded INTEGER,"
          "purpose INTEGER,"
          "windDirection TEXT,"
          "werkput TEXT,"
          "vlak TEXT,"
          "spoor TEXT,"
          "coupe TEXT,"
          "profiel TEXT,"
          "structuur TEXT,"
          "vondst TEXT,"
          "gphotoId TEXT"
          ");"
        );
      var result = await db.query(currentTable, orderBy: 'id ASC');
      return result;
    }
  }

  // Insert Operation: Insert a ImageFind object to database
  Future<int> insertImageFind(ImageFind proj) async {
    //final db = await dbProvider.database;
    //Database db = await this.database;
    Database db = await dbProvider.database;
    var result = await db.insert(currentTable, proj.toMap());
    return result;
  }

  // Update Operation: Update a ImageFind object and save it to database
  Future<int> updateImageFind(ImageFind proj) async {
    //final db = await dbProvider.database;   
    Database db = await dbProvider.database;
    var result = await db.update(currentTable, proj.toMap(), where: 'id = ?', whereArgs: [proj.id]);
    return result;
  }

  // Delete Operation: Delete a ImageFind object from database
  Future<int> deleteImageFind(int id) async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $currentTable WHERE id = $id');
    return result;
  }

  // Get number of ImageFind objects in database
  Future<int> getCount() async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $currentTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'ImageFind List' [ List<ImageFind> ]
  Future<List<ImageFind>> getImageFindList(int source) async {
    //final db = await dbProvider.database;
    //Database db = await dbProvider.database;
    var imageFindMapList = await getImageFindMapList(source); // Get 'Map List' from database
    int count = imageFindMapList.length;         // Count the number of map entries in db table

    List<ImageFind> imageFindList = [];
    // For loop to create a 'ImageFind List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      imageFindList.add(ImageFind.fromMapObject(imageFindMapList[i]));
    }

    return imageFindList;
  }
}