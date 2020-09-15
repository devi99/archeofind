import 'dart:async';
import 'dart:convert';
import 'package:archeofind/models/imageFind.dart';
import 'package:archeofind/services/database.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/services/database_imagefind_helpers.dart';
import 'package:archeofind/widgets/imageFindDetail.dart';
import 'package:http/http.dart' as http;

class ImageFindList extends StatefulWidget{
  ImageFindList(this.listToShow);

  final int listToShow;

  @override
  State<StatefulWidget> createState() {

    return ImageFindListState();
  }
}

class ImageFindListState extends State<ImageFindList>{

  DatabaseImageFindHelper databaseHelper=new DatabaseImageFindHelper();
  DatabaseProvider dbProvider;  
  
  List<ImageFind> imageFindlist;
  int count=0;

  @override
  Widget build(BuildContext context) {
    if(imageFindlist==null){
      imageFindlist=List<ImageFind>();
      updateListView(widget.listToShow);
    }
    if(widget.listToShow == 0){
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Images'),
      // ),
      body: getImageListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         navigateToDetail(ImageFind(),'Add Image');
        },
        tooltip: 'Add Image',
        child: Icon(Icons.add),
      ),
    );
    }else{
    return Scaffold(
      appBar: AppBar(
        title: Text('SYNC'),
      ),
      body: getImageListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          syncImages();
        },
        tooltip: 'Sync to Db',
        child: Icon(Icons.sync),
      ),
    );
    }

  }

  ListView getImageListView(){
    TextStyle titleStyle=Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext cotext,int position){
        String concatTitle = (this.imageFindlist[position].werkput != null) ? "#" + this.imageFindlist[position].werkput.toString() : "";
        concatTitle += (this.imageFindlist[position].vlak != null) ? "#" + this.imageFindlist[position].vlak.toString() : "";
        concatTitle += (this.imageFindlist[position].spoor != null) ? "#" + this.imageFindlist[position].spoor.toString() : "";
        concatTitle += (this.imageFindlist[position].coupe != null) ? "#" + this.imageFindlist[position].coupe.toString() : "";
        concatTitle += (this.imageFindlist[position].profiel != null) ? "#" + this.imageFindlist[position].profiel.toString() : "";
        concatTitle += (this.imageFindlist[position].structuur != null) ? "#" + this.imageFindlist[position].structuur.toString() : "";
        return Card(
          color: Colors.white,
          elevation: 20,
          child: ListTile(
            leading: CircleAvatar
              (
              backgroundColor: getPriorityColor(this.imageFindlist[position].type),
              child: getPriorityIcon(this.imageFindlist[position].type),
            ),
            title: Text(concatTitle ,style: titleStyle),
            subtitle: Text(this.imageFindlist[position].project.toString()),
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

  void _delete(BuildContext context, ImageFind img) async {

    int result = await databaseHelper.deleteImageFind(img.id);
    if (result != 0) {
      _showSnackBar(context, 'Deleted Successfully');
       updateListView(widget.listToShow);
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(ImageFind img,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return ImageFindDetail(img,title);
    }));

   if(result==true){
     updateListView(widget.listToShow);
   }
  }

  void updateListView(int listToShow) {
    Future<List<ImageFind>> imgListFuture = databaseHelper.getImageFindList(listToShow);
    imgListFuture.then((imageFindlist) {
      setState(() {
        this.imageFindlist = imageFindlist;
        this.count = imageFindlist.length;
      });
    });

  } 
  
  void syncImages() {
    Future<List<ImageFind>> imgListFuture = databaseHelper.getImageFindList(0);
    imgListFuture.then((imageFindlist) {
      for (ImageFind imageFind in imageFindlist) {
        debugPrint(imageFind.id.toString());
        Future<int>_futureAlbum = createEntry(imageFind);
        debugPrint(_futureAlbum.toString());
      }
    });
  }

  Future<int> createEntry(ImageFind _imageFind) async {
    String json = '''
      {
        "type":${_imageFind.type},
        "date":${_imageFind.date},
        "name":"${_imageFind.name}",
        "project":"${_imageFind.project}",
        "purpose":${_imageFind.purpose},
        "windDirection":"${_imageFind.windDirection}",
        "werkput":"${_imageFind.werkput}",
        "vlak":"${_imageFind.vlak}",
        "spoor":"${_imageFind.spoor}",
        "coupe":"${_imageFind.coupe}",
        "profiel":"${_imageFind.profiel}",  
        "structuur":"${_imageFind.structuur}",
        "vondst":"${_imageFind.vondst}"                                                
        }
      ''';
      //'https://postman-echo.com/post',
    final http.Response response = await http.post(
      'http://demo.archeofinds.lares.eu.meteorapp.com/api/v1/import/photo',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json),
    );

    if (response.statusCode == 200) {
      _imageFind.uploaded = 1;
      int result = await databaseHelper.updateImageFind(_imageFind);
      return (result);
    } else {
      throw Exception('Failed to create album.');
    }
  }
}