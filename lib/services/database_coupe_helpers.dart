import 'package:archeofind/models/coupe.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:archeofind/services/database.dart';

class DatabaseCoupeHelper
{

  static Database db;  
  String currentTable = 'Coupes';
  final String colId = 'id';
  final String colName = 'name';
  final String colDig = 'dig';
  final String colImage = 'image';
  DatabaseProvider dbProvider=DatabaseProvider();

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getCoupeMapList() async {
    Database db = await dbProvider.database;
    try {
      var result = await db.query(currentTable, orderBy: 'id ASC');
      return result;
    } catch (e) {
      await db.execute("CREATE TABLE Coupes ("
          "id integer primary key AUTOINCREMENT,"
          "name TEXT,"
          "dig TEXT,"
          "level TEXT,"
          "image TEXT,"
          "depth INTEGER,"
          "date INTEGER"
          ");"
        );
      var result = await db.query(currentTable, orderBy: 'id ASC');
      return result;
    }
  }

  Future<Coupe> getCoupe(int id) async {
    try {
      Database db = await dbProvider.database;
      List<Map> maps = await db.query(currentTable,
      columns: [colId, colName, colDig, colImage],
      where: '$colId = ?',
      whereArgs: [id]);
      if (maps.length > 0) {
        return Coupe.fromMapObject(maps.first);
      }
      return null;
    }catch(e){
      debugPrint(e);
      return null;
    }


  }

  // Insert Operation: Insert a Coupe object to database
  Future<int> insertCoupe(Coupe proj) async {
    //final db = await dbProvider.database;
    //Database db = await this.database;
    Database db = await dbProvider.database;
    var result = await db.insert(currentTable, proj.toMap());
    return result;
  }

  // Update Operation: Update a Coupe object and save it to database
  Future<int> updateCoupe(Coupe proj) async {
    //final db = await dbProvider.database;   
    Database db = await dbProvider.database;
    var result = await db.update(currentTable, proj.toMap(), where: 'id = ?', whereArgs: [proj.id]);
    return result;
  }

  // Delete Operation: Delete a Coupe object from database
  Future<int> deleteCoupe(int id) async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $currentTable WHERE id = $id');
    return result;
  }

  // Get number of Coupe objects in database
  Future<int> getCount() async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $currentTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Coupe List' [ List<Coupe> ]
  Future<List<Coupe>> getCoupeList() async {
    //final db = await dbProvider.database;
    //Database db = await dbProvider.database;
    var coupeMapList = await getCoupeMapList(); // Get 'Map List' from database
    int count = coupeMapList.length;         // Count the number of map entries in db table

    List<Coupe> coupeList = List<Coupe>();
    // For loop to create a 'Coupe List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      coupeList.add(Coupe.fromMapObject(coupeMapList[i]));
    }

    return coupeList;
  }
}