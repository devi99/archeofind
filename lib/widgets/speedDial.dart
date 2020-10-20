import 'dart:io';

import 'package:archeofind/models/imageFind.dart';
import 'package:archeofind/models/photos_library_api_model.dart';
import 'package:archeofind/photos_library_api/batch_create_media_items_response.dart';
import 'package:archeofind/services/database_imagefind_helpers.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class SpeedDial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SpeedDialState();
}

class SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  
  DatabaseImageFindHelper databaseHelper=new DatabaseImageFindHelper();

  bool _isOpened = false;

  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  // this is needed to know how much to "translate"
  double _fabHeight = 56.0;
  // when the menu is closed, we remove elevation to prevent 
  // stacking all elevations
  bool _shouldHaveElevation = false;

  bool isSuccessFromApi = false;
  bool isLoading = false;
  
  @override
  initState() {
   // a bit faster animation, which looks better: 300
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    
   // this does the translation of menu items
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  void animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
    // here we update whether or not they FABs should have elevation
    _shouldHaveElevation = !_shouldHaveElevation;
  }

  void syncImages(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Future<List<ImageFind>> imgListFuture = databaseHelper.getImageFindList(0);
    imgListFuture.then((imageFindlist) async {
      for (ImageFind imageFind in imageFindlist) {
        debugPrint(imageFind.id.toString());
        final File image = File(imageFind.name);
        debugPrint(imageFind.name);
            // Make a request to upload the image to Google Photos once it was selected.
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
    setState(() {
      isLoading = false;
      isSuccessFromApi = true;
    });
    _showSnackBar(context, "sync finished !");
  }
  
  void deleteImages(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Future<List<ImageFind>> imgListFuture = databaseHelper.getImageFindList(1);
    imgListFuture.then((imageFindlist) async {
      for (ImageFind imageFind in imageFindlist) {
        debugPrint(imageFind.name);
        try {
          final file = File(imageFind.name);
          await file.delete();
          await databaseHelper.deleteImageFind(imageFind.id);
        } catch (e) {
          await databaseHelper.deleteImageFind(imageFind.id);
        }
      }
    });
    setState(() {
      isLoading = false;
      isSuccessFromApi = true;
    });
    _showSnackBar(context, "all images deleted from device !");
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

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void showConfirmationDialog(BuildContext context, String targetFunction) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
        if (targetFunction == "sync") {
          syncImages(context);
        } else{
          deleteImages(context);
        } 
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: !isSuccessFromApi ? Container(
          child: Text('Are you Sure???'),
        ) : Container( child: isLoading ? CircularProgressIndicator() : Text('Success'),),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget syncButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnSync",
        onPressed: () async {
          showConfirmationDialog(context, "sync");
          // bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
          //   return ProjectDetail(Project('',1234,2),'');
          // }));
          // if(result==true){
          //   //updateListView();
          //}
        },
        tooltip: 'Sync',
        child: Icon(Icons.sync),
        elevation: _shouldHaveElevation ? 6.0 : 0,
      ),
    );
  }

  Widget deleteButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnDeleteAll",
        onPressed: () {
          showConfirmationDialog(context, "delete");
        },
        tooltip: 'Delete All',
        child: Icon(Icons.delete),
        elevation: _shouldHaveElevation ? 6.0 : 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: syncButton(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: deleteButton(),
        ),
      ],
    );
  }
}