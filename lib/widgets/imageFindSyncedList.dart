import 'dart:async';
import 'package:archeofind/models/imageFind.dart';
import 'package:archeofind/services/database.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/services/database_imagefind_helpers.dart';
import 'package:archeofind/widgets/imageFindDetail.dart';
//import 'package:sqflite/sqflite.dart';

class ImageFindSyncedList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return ImageFindSyncedListState();
  }
}

class ImageFindSyncedListState extends State<ImageFindSyncedList>{

  DatabaseImageFindHelper databaseHelper=new DatabaseImageFindHelper();
  DatabaseProvider dbProvider;  
  
  List<ImageFind> imageFindlist;
  int count=0;
  @override
  Widget build(BuildContext context) {
    if(imageFindlist==null){
      imageFindlist=List<ImageFind>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
      ),
      body: getImageListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint("FAB Clicked");

         navigateToDetail(ImageFind(),'Add Image');
        },
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getImageListView(){
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
              backgroundColor: getPriorityColor(this.imageFindlist[position].type),
              child: getPriorityIcon(this.imageFindlist[position].type),
            ),
            title: Text(this.imageFindlist[position].date.toString() ,style: titleStyle),
            subtitle: Text(this.imageFindlist[position].id.toString()),
            onTap: (){
              navigateToDetail(this.imageFindlist[position],'Edit Image');
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
      case 3:
        return Colors.blue;
        break;
      case 4:
        return Colors.green;
        break;
      case 5:
        return Colors.black;
        break;
      case 6:
        return Colors.orange;
        break;
      case 7:
        return Colors.brown;
        break;
      case 8:
        return Colors.indigo;
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

  // void _delete(BuildContext context, ImageFind img) async {

  //   int result = await databaseHelper.deleteImageFind(img.id);
  //   if (result != 0) {
  //     _showSnackBar(context, 'Deleted Successfully');
  //      updateListView();
  //   }
  // }

  // void _showSnackBar(BuildContext context, String message) {

  //   final snackBar = SnackBar(content: Text(message));
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

  void navigateToDetail(ImageFind img,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return ImageFindDetail(img,title);
    }));

   if(result==true){
     updateListView();
   }
  }

  void updateListView() {
    Future<List<ImageFind>> imgListFuture = databaseHelper.getImageFindList(2);
    imgListFuture.then((imageFindlist) {
      setState(() {
        this.imageFindlist = imageFindlist;
        this.count = imageFindlist.length;
      });
    });

  } 
}