import 'package:archeofind/models/coupe.dart';
import 'package:archeofind/services/database_coupe_helpers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:archeofind/pages/take_picture_page.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CoupeDetail extends StatefulWidget{

  final String appBarTitle;
  final Coupe _coupe;
  
  CoupeDetail(this._coupe,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CoupeDetailState(this._coupe,this.appBarTitle);
  }
} 

class CoupeDetailState extends State<CoupeDetail>{

  dynamic _pickImageError;
  String _retrieveDataError;
  // final TextEditingController maxWidthController = TextEditingController();
  // final TextEditingController maxHeightController = TextEditingController();
  // final TextEditingController qualityController = TextEditingController();

  DatabaseCoupeHelper databaseHelper=DatabaseCoupeHelper();

  Coupe _coupe;
  // ignore: unused_field
  String _path = '';
  String appBarTitle;
  TextEditingController nameController = TextEditingController();
  TextEditingController digController = TextEditingController();

  CoupeDetailState(this._coupe,this.appBarTitle);

   Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_coupe.image != null) {
      return Image.file(File(_coupe.image));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }


  Widget build(BuildContext context) {

    //if(_coupe.id !=null){
      getCoupeData(_coupe.id);
    //}

    TextStyle textStyle=Theme.of(context).textTheme.headline6;

    nameController.text=this._coupe.name;
    digController.text=this._coupe.dig;

    return new WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(
            Icons.arrow_back),
              onPressed: (){
                moveToLastScreen();
              }
            ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
          child: ListView(
            children: <Widget>[

              //first element
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('Something changed in name text field');
                    updateName();
                  },
                  decoration: InputDecoration(
                    labelText: 'Nr',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: digController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('Something changed in tiltle text field');
                    updateDig();
                  },
                  decoration: InputDecoration(
                    labelText: 'Werkput',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //Second Element
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: FlatButton(
                  child: Text("Take Picture", style: TextStyle(color: Colors.white)),
                  color: Colors.green, 
                  onPressed: () {
                   _showOptions(context);
                  },
                ),
              ), 

              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: Center(
                  child: _previewImage()
                ),
              ),
              
              //Third Element
              Padding(
               padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint("Save button clicked");
                          _save();
                        });
                      },
                    ),
                  ),

                  Container(width: 5.0,),
                  //delete button
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: (){
                        setState(() {
                          debugPrint("Delete button clicked");
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )

            ]
          ),
        )
      )
    );
  }



  void _showPhotoLibrary() async {

    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery
    );

    setState(() {
      _coupe.image = pickedFile.path; 
      _save();     
    });

  }

  void _showCamera() async {

    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));
  
    setState(() {
      _coupe.image = result; 
      _save();      
    });
  
  }

  void _showOptions(BuildContext context) {
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.pop(context); 
                _showCamera(); 
              },
              leading: Icon(Icons.photo_camera),
              title: Text("Take a picture from camera")
            ), 
            ListTile(
              onTap: () {
                Navigator.pop(context); 
                _showPhotoLibrary(); 
              },
              leading: Icon(Icons.photo_library),
              title: Text("Choose from photo library")
            )
          ])
        );
      }
    );

  }

  void moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void updateName(){
    _coupe.name = nameController.text;
  }

  void updateDig(){
    _coupe.dig = digController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    //_coupe.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (_coupe.id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateCoupe(_coupe);
    } else { // Case 2: Insert Operation
      result = await databaseHelper.insertCoupe(_coupe);
    }
    
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Coupe Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Coupe');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (_coupe.id == null) {
      _showAlertDialog('Status', 'No Coupe was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteCoupe(_coupe.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Coupe Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Coupe');
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

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  void getCoupeData(int _id) {
    Future<Coupe> coupFuture = databaseHelper.getCoupe(_id);

    coupFuture.then((coup) {
       setState(() {
         _coupe = coup;
    //     this.count = coupList.length;
       });
    });
  } 
}

  typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);
