import 'dart:async';
import 'package:archeofind/services/database.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/models/project.dart';
import 'package:archeofind/services/database_project_helpers.dart';
import 'package:archeofind/widgets/projectDetail.dart';
//import 'package:sqflite/sqflite.dart';

class ProjectList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return ProjectListState();
  }
}

class ProjectListState extends State<ProjectList>{

  DatabaseProjectHelper databaseHelper=new DatabaseProjectHelper();
  DatabaseProvider dbProvider;  
  
  List<Project> projlist;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(projlist==null){
      projlist=List<Project>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
      ),
      body: getProjectListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("FAB Clicked");

         navigateToDetail(Project('',DateTime.now().millisecondsSinceEpoch,2),'Add Project');
        },
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getProjectListView(){
    TextStyle titleStyle=Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext cotext,int position){
        return Card(
          color: Colors.white,
          elevation: 20,
          child: ListTile(
            leading: CircleAvatar
              (
              backgroundColor: getPriorityColor(this.projlist[position].type),
              child: getPriorityIcon(this.projlist[position].type),
            ),
            title: Text(this.projlist[position].name,style: titleStyle,),
            subtitle: Text(this.projlist[position].start.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey,),
              onTap: (){
                _delete(context, projlist[position]);
              },
            ),
            onTap: (){
              debugPrint("testing");
              navigateToDetail(this.projlist[position],'Edit Project');

            },
          ),

        );
      },
    );
  }

  Color getPriorityColor(int type){
    switch (type){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the type icon
  Icon getPriorityIcon(int type) {
    switch (type) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Project proj) async {

    int result = await databaseHelper.deleteProject(proj.id);
    if (result != 0) {
      _showSnackBar(context, 'Project Deleted Successfully');
       updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Project proj,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return ProjectDetail(proj,title);
    }));

   if(result==true){
     updateListView();
   }
  }

  void updateListView() {
    Future<List<Project>> projListFuture = databaseHelper.getProjectList();
    projListFuture.then((projList) {
      setState(() {
        this.projlist = projList;
        this.count = projList.length;
      });
    });
/*     final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Project>> projListFuture = databaseHelper.getProjectList();
      projListFuture.then((projList) {
        setState(() {
          this.projlist = projList;
          this.count = projList.length;
        });
      });
    }); */
  } 
}