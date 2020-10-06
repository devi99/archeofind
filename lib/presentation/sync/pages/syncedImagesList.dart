import 'dart:async';
import 'dart:io';
import 'package:archeofind/models/imageFind.dart';
import 'package:archeofind/models/photos_library_api_model.dart';
import 'package:archeofind/photos_library_api/batch_create_media_items_response.dart';
import 'package:archeofind/services/database.dart';
import 'package:flutter/material.dart';
import 'package:archeofind/services/database_imagefind_helpers.dart';
import 'package:archeofind/widgets/imageFindDetail.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class SyncedImagesList extends StatefulWidget{
    static Route<dynamic> route() => MaterialPageRoute(
      builder: (context) => SyncedImagesList(),
    );

  @override
  State<StatefulWidget> createState() {

    return SyncedImagesListState();
  }
}

class SyncedImagesListState extends State<SyncedImagesList>{

  DatabaseImageFindHelper databaseHelper=new DatabaseImageFindHelper();
  DatabaseProvider dbProvider;  
  
  List<ImageFind> imageFindlist;
  int count=0;

  @override
  Widget build(BuildContext context) {
    if(imageFindlist==null){
      imageFindlist=List<ImageFind>();
      updateListView(1);
    }
    //updateListView(1);
    return Scaffold(
      appBar: AppBar(
        title: Text('SYNC'),
      ),
      body: getImageListView(),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnSync",
        onPressed: (){
          syncImages();
        },
        tooltip: 'Sync to Db',
        child: Icon(Icons.sync),
      ),
    );
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

  void navigateToDetail(ImageFind img,String title) async{
   bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
      return ImageFindDetail(img,title);
    }));

   if(result==true){
     updateListView(1);
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
    imgListFuture.then((imageFindlist) async {
      for (ImageFind imageFind in imageFindlist) {
        debugPrint(imageFind.id.toString());
        final File image = File(imageFind.name);
        debugPrint(imageFind.name);
            // Make a request to upload the image to Google Photos once it was selected.
        //final String uploadToken = 'CAIS+QIAqD4uLYuZP6HCdmPL6whnGJp6xAYZB8pyWM49078fpXJcYcH/NyKB/CVnhlR5SD4akh/I1XdRKDuFIvntlRJhJw53E1AlV4maJDkqjCJOyLJUAYyCUFXluu8+5aqVKuvm9EwMcaQAqAUpkZiaTSWBgsbv10imJlUaA3f4u4T6DaksETd/oaA4jxbfHJA5uaXITDkfhL0IZzkn7uW0QUZZtF3sEC2JdY4gdGyd8aFU1Wnwj4hNKAp3UpehNdZtI7BK+cU//oT2BJ0I+QFiAgenv/7pQIE8Fr/tN1EFarF291uau6GgifpSWzsJ7Tqtc6sn798PukidP16uvCrWDTGmiDVUR+90nIe+L8Rgb3YuZOuA5lNTbNokhk95EWewuov8V6pVvVKznCMfolCMz6CsF5G42CSfNdcLX+RqWt0t0O0c/0j0ZSz+SpluszpN13zXO1zvFK0dSxG9RtWlBtyGMg86I0EOkwC5IA9N6V2pkTk76y+xAsGbBw';
        final String uploadToken =
          await ScopedModel.of<PhotosLibraryApiModel>(context)
            .uploadMediaItem(image);
        debugPrint(uploadToken);
        final BatchCreateMediaItemsResponse uploadedItem =
          await ScopedModel.of<PhotosLibraryApiModel>(context)
            .createMediaItem(uploadToken, '', '');
        debugPrint(uploadedItem.toString());
        imageFind.gphotoId = uploadedItem.newMediaItemResults[0].mediaItem.id;
        Future<int>_futureAlbum = createEntry(imageFind);
        debugPrint(_futureAlbum.toString());
      }
    });
  }

  Future<int> createEntry(ImageFind _imageFind) async {
    // var _fullFilename = _imageFind.name;
    // int lastSlash = _fullFilename.lastIndexOf('/')+1; 
    // var _shortFilename = _fullFilename.substring(lastSlash, _fullFilename.length); // 'art'
    String json = '''
      {
        "type":${_imageFind.type},
        "date":${_imageFind.date},
        "name":"${_imageFind.gphotoId}",
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
    debugPrint(json.toString());
    final http.Response response = await http.post(
      'http://demo.archeofinds.lares.eu.meteorapp.com/api/v1/import/photo',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json,
    );

    if (response.statusCode == 200) {
      _imageFind.uploaded = 1;
      int result = await databaseHelper.updateImageFind(_imageFind);
      return (result);
    } else {
      _showAlertDialog('Status', 'Something went wrong error ' + response.statusCode.toString());
      throw Exception('Failed to create album.');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}