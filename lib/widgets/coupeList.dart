import 'dart:async';
import 'package:archeofind/services/database.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/models/coupe.dart';
import 'package:archeofind/services/database_coupe_helpers.dart';
import 'package:archeofind/widgets/coupeDetail.dart';
//import 'package:sqflite/sqflite.dart';

class CoupeList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return CoupeListState();
  }
}

class CoupeListState extends State<CoupeList>{

  DatabaseCoupeHelper databaseHelper=new DatabaseCoupeHelper();
  DatabaseProvider dbProvider;  
  
  List<Coupe> coupList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(coupList==null){
      coupList=List<Coupe>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupes'),
      ),
      body: getCoupeListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("Add Coupe Clicked");

         navigateToDetail(Coupe(),'Add Coupe');
        },
        tooltip: 'Add Coupe',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getCoupeListView(){
    TextStyle titleStyle=Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext cotext,int position){
        return Card(
          color: Colors.white,
          elevation: 20,
          child: ListTile(
            title: Text(this.coupList[position].name,style: titleStyle,),
            subtitle: Text(this.coupList[position].date.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.grey,),
              onTap: (){
                _delete(context, coupList[position]);
              },
            ),
            onTap: (){
              debugPrint("testing");
              navigateToDetail(this.coupList[position],'Edit Coupe');

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

  void _delete(BuildContext context, Coupe proj) async {

    int result = await databaseHelper.deleteCoupe(proj.id);
    if (result != 0) {
      _showSnackBar(context, 'Coupe Deleted Successfully');
       updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Coupe proj,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return CoupeDetail(proj,title);
    }));

   if(result==true){
     updateListView();
   }
  }

  void updateListView() {
    Future<List<Coupe>> coupListFuture = databaseHelper.getCoupeList();
    coupListFuture.then((coupList) {
      setState(() {
        this.coupList = coupList;
        this.count = coupList.length;
      });
    });
  } 
}