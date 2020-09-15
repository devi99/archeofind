
import 'package:archeofind/models/project.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:archeofind/services/database.dart';

class DatabaseProjectHelper
{

  static Database db;  
  String currentTable = 'Projects';
  DatabaseProvider dbProvider=DatabaseProvider();

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getProjectMapList() async {
    Database db = await dbProvider.database;
  //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(currentTable, orderBy: 'type ASC');
    return result;
  }

  // Insert Operation: Insert a Project object to database
  Future<int> insertProject(Project proj) async {
    //final db = await dbProvider.database;
    //Database db = await this.database;
    Database db = await dbProvider.database;
    var result = await db.insert(currentTable, proj.toMap());
    return result;
  }

  // Update Operation: Update a Project object and save it to database
  Future<int> updateProject(Project proj) async {
    //final db = await dbProvider.database;   
    Database db = await dbProvider.database;
    var result = await db.update(currentTable, proj.toMap(), where: 'id = ?', whereArgs: [proj.id]);
    return result;
  }

  // Delete Operation: Delete a Project object from database
  Future<int> deleteProject(int id) async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    int result = await db.rawDelete('DELETE FROM $currentTable WHERE id = $id');
    return result;
  }

  // Get number of Project objects in database
  Future<int> getCount() async {
    //final db = await dbProvider.database;
    Database db = await dbProvider.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $currentTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Project List' [ List<Project> ]
  Future<List<Project>> getProjectList() async {
    //final db = await dbProvider.database;
    //Database db = await dbProvider.database;
    var projectMapList = await getProjectMapList(); // Get 'Map List' from database
    int count = projectMapList.length;         // Count the number of map entries in db table

    List<Project> projectList = List<Project>();
    // For loop to create a 'Project List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      projectList.add(Project.fromMapObject(projectMapList[i]));
    }

    return projectList;
  }
}