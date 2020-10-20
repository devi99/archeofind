import 'dart:io';
import 'package:archeofind/models/imageFind.dart';
import 'package:archeofind/pages/take_picture_page.dart';
import 'package:archeofind/services/database_imagefind_helpers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageFindDetail extends StatefulWidget{

  final String appBarTitle;
  final ImageFind _imageFind;

  ImageFindDetail(this._imageFind,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ImageFindDetailState(this._imageFind,this.appBarTitle);
  }
}

class ImageFindDetailState extends State<ImageFindDetail>{
  dynamic _pickImageError;
  String _retrieveDataError;

  bool _isVisibleName = false;
  bool _isVisiblePurpose = false;
  bool _isVisibleWindDirection = false;
  bool _isVisibleWerkput = false;
  bool _isVisibleVlak = false;
  bool _isVisibleSpoor = false;
  bool _isVisibleCoupe = false;
  bool _isVisibleProfiel = false;
  bool _isVisibleStructuur = false;
  bool _isVisibleVondst = false;

  DatabaseImageFindHelper databaseHelper=DatabaseImageFindHelper();
  static var _types=['Terrein','Sfeer', 'Vlak', 'Spoor', 'Coupe', 'Profiel', 'Structuur', 'Vondst'];
  static var _purpose=['Overzicht','Deeloverzicht', 'Kijkvenster', 'Profielrelatie', 'Detail', 'Monstername'];

  ImageFind _imageFind;
  String appBarTitle;
  TextEditingController nameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController projectController = TextEditingController();
  TextEditingController windDirectionController = TextEditingController();
  TextEditingController werkputController = TextEditingController();
  TextEditingController vlakController = TextEditingController();
  TextEditingController spoorController = TextEditingController();
  TextEditingController coupeController = TextEditingController();
  TextEditingController profielController = TextEditingController();
  TextEditingController structuurController = TextEditingController();
  TextEditingController vondstController = TextEditingController();
  
  ImageFindDetailState(this._imageFind,this.appBarTitle);

  
   Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFind.name != null) {
      return Image.file(File(_imageFind.name));
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
    TextStyle textStyle=Theme.of(context).textTheme.headline6;
    //_imageFind.copyright = 'Lares 2020';

    nameController.text=_imageFind.name;
//    purposeController.text=_imageFind.purpose;
    if(_imageFind.project == null){
      loadProject();
    }else{
      projectController.text=_imageFind.project;
    }
    projectController.text=_imageFind.project;
    windDirectionController.text = _imageFind.windDirection;
    werkputController.text = _imageFind.werkput;
    vlakController.text = _imageFind.vlak;
    spoorController.text = _imageFind.spoor;
    coupeController.text = _imageFind.coupe;
    profielController.text = _imageFind.profiel;
    structuurController.text = _imageFind.structuur;
    vondstController.text = _imageFind.vondst;

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
              ListTile(
                title: DropdownButton(
                  items: _types.map((String dropDownStingItem){
                    return DropdownMenuItem<String>(
                      value: dropDownStingItem,
                      child: Text(dropDownStingItem),
                    );
                  }).toList(),

                  style: textStyle,
                  value: getTypeAsString(_imageFind.type),
                  onChanged: (valueSelectedByUser){
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updateTypeAsInt(valueSelectedByUser);
                      updateVisibility(valueSelectedByUser);
                    });
                  },
                  hint: Text('Selecteer Type')
                ),            
              ),

              //Second Element
              Visibility (
                visible: _isVisibleName,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in name text field');
                      updateController('name');
                    },
                    decoration: InputDecoration(
                      labelText: 'Naam',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),
              
              Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: projectController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('project');
                    },
                    decoration: InputDecoration(
                      labelText: 'Project',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),

              //Third Element
              Visibility (
                visible: _isVisiblePurpose,
                child:ListTile(
                  title: DropdownButton(
                    items: _purpose.map((String dropDownStingItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStingItem,
                        child: Text(dropDownStingItem),
                      );
                    }).toList(),

                    style: textStyle,
                    value: getPurposeAsString(_imageFind.purpose),
                    onChanged: (valueSelectedByUser){
                      setState(() {
                        debugPrint('User selected $valueSelectedByUser');
                        updatePurposeAsInt(valueSelectedByUser);
                      });
                    },
                    hint: Text('Selecteer Doel')
                  ),            
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleWindDirection,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: windDirectionController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('windDirection');
                    },
                    decoration: InputDecoration(
                      labelText: 'Windrichting',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),
              
              //Third Element
              Visibility (
                visible: _isVisibleWerkput,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: werkputController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('werkput');
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
              ),
              //Third Element

              Visibility (
                visible: _isVisibleVlak,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: vlakController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('vlak');
                    },
                    decoration: InputDecoration(
                      labelText: 'Vlak',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleSpoor,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: spoorController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('spoor');
                    },
                    decoration: InputDecoration(
                      labelText: 'Spoor',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleCoupe,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: coupeController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('coupe');
                    },
                    decoration: InputDecoration(
                      labelText: 'Coupe',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleProfiel,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: profielController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('profiel');
                    },
                    decoration: InputDecoration(
                      labelText: 'Profiel',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleStructuur,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: structuurController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('structuur');
                    },
                    decoration: InputDecoration(
                      labelText: 'Structuur',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  ),
                ),
              ),

              //Third Element
              Visibility (
                visible: _isVisibleVondst,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                  child: TextField(
                    controller: vondstController,
                    style: textStyle,
                    onChanged: (value){
                      debugPrint('Something changed in purpose text field');
                      updateController('vondst');
                    },
                    decoration: InputDecoration(
                      labelText: 'Vondst',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
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
                            
              //Fourth element
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
          )
        )
      )
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context,true);
  }
  void loadProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _project = prefs.getString('projectName');
    if(_project != null){
      projectController.text = prefs.getString('projectName');
      _imageFind.project = prefs.getString('projectId');
    }
  }
  
  void loadVlak() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_imageFind.werkput == null){
      String _werkput = prefs.getString('werkput');
      if(_werkput != null){
      werkputController.text = prefs.getString('werkput');
       _imageFind.werkput = prefs.getString('werkput');
      }
    }
    if(_imageFind.vlak == null){
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      String _vlak = prefs.getString('vlak');
      if(_vlak != null){
        vlakController.text = prefs.getString('vlak');
        _imageFind.vlak = prefs.getString('vlak');
      }      
    }
  }

  void loadSpoor() async {
    loadVlak();
    if(_imageFind.spoor == null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      spoorController.text = prefs.getString('spoor');
      _imageFind.spoor = prefs.getString('spoor');
    }
  }
    
// Convert int priority to String priority and display it to user in DropDown
  String getTypeAsString(int value) {
    String type;
    switch (value) {
      case 1:
        type = _types[0];  // 'High'
        break;
      case 2:
        type = _types[1];  // 'Low'
        break;
      case 3:
        type = _types[2];  // 'Low'
        break;
      case 4:
        type = _types[3];  // 'Low'
        break;
      case 5:
        type = _types[4];  // 'Low'
        break;
      case 6:
        type = _types[5];  // 'Low'
        break;
      case 7:
        type = _types[6];  // 'Low'
        break;
      case 8:
        type = _types[7];  // 'Low'
        break;                  
    }
    updateVisibility(value);
  return type;
}
  
  void updateTypeAsInt(String value) {

  switch (value) {
    case 'Terrein':
      _imageFind.type = 1;   
      updateVisibility(1);   	
      break;
    case 'Sfeer':
      _imageFind.type = 2;    
      updateVisibility(2);   	
      break;
    case 'Vlak':
      _imageFind.type = 3;
      updateVisibility(3);
      break;
    case 'Spoor':
      _imageFind.type = 4;
      updateVisibility(4);
      break;
    case 'Coupe':
      _imageFind.type = 5;      
      updateVisibility(5);
      break;
    case 'Profiel':
      _imageFind.type = 6;
      updateVisibility(6);      
      break;
    case 'Structuur':
      _imageFind.type = 7;
      updateVisibility(7);       
      break;        
    case 'Vondst':
      _imageFind.type = 8;
      updateVisibility(8);     
      break;                        
  }
}

  String getPurposeAsString(int value) {
    String purpose;
    switch (value) {
      case 1:
        purpose = _purpose[0];  // 'High'
        break;
      case 2:
        purpose = _purpose[1];// 'Low'
        break;
      case 3:
        purpose = _purpose[2];  // 'Low'
        break;
      case 4:
        purpose = _purpose[3];  // 'Low'
        break;
      case 5:
        purpose = _purpose[4];  // 'Low'
        break;
      case 6:
        purpose = _purpose[5];  // 'Low'
        break;               
    }
  return purpose;
}
  
  void updatePurposeAsInt(String value) {
    switch (value) {
      case 'Overzicht':
        _imageFind.purpose = 1;	
        break;
      case 'Deeloverzicht':
        _imageFind.purpose = 2;   	
        break;
      case 'Kijkvenster':
        _imageFind.purpose = 3;
        break;
      case 'Profielrelatie':
        _imageFind.purpose = 4;
        break;
      case 'Detail':
        _imageFind.purpose = 5; 
        break;
      case 'Monstername':
        _imageFind.purpose = 6;    
        break;
    }
  }
  
  void updateVisibility(int inputType){
    switch (inputType) {
      case 1:
        setState(() {
        _isVisiblePurpose = true;
        _isVisibleWindDirection = true;
        _isVisibleWerkput = false;
        _isVisibleVlak = false;
        _isVisibleSpoor = false;
        _isVisibleCoupe = false;
        _isVisibleProfiel = false;
        _isVisibleStructuur = false;
        _isVisibleVondst = false;
        });
        break;
      case 2:
        setState(() {
          _isVisiblePurpose = false;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = false;
          _isVisibleVlak = false;
          _isVisibleSpoor = false;
          _isVisibleCoupe = false;
          _isVisibleProfiel = false;
          _isVisibleStructuur = false;
          _isVisibleVondst = false;          
        });
        break;
      case 3:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = false;
          _isVisibleCoupe = false;
          _isVisibleProfiel = false;
          _isVisibleStructuur = false;
          _isVisibleVondst = false;           
        });   
        loadVlak();
        break;
      case 4:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = true;
          _isVisibleCoupe = true;
          _isVisibleProfiel = false;
          _isVisibleStructuur = false;
          _isVisibleVondst = false;           
        });   
        loadSpoor();
        break;
      case 5:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = true;
          _isVisibleCoupe = true;
          _isVisibleProfiel = false;
          _isVisibleStructuur = false;
          _isVisibleVondst = false;           
        });   
        loadVlak();
        break;
      case 6:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = false;
          _isVisibleCoupe = false;
          _isVisibleProfiel = true;
          _isVisibleStructuur = false;
          _isVisibleVondst = false;           
        });     
        loadVlak(); 
        break;
      case 7:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = false;
          _isVisibleCoupe = false;
          _isVisibleProfiel = false;
          _isVisibleStructuur = true;
          _isVisibleVondst = false;           
        });       
        loadVlak();        
        break;
      case 8:
        setState(() {
          _isVisiblePurpose = true;
          _isVisibleWindDirection = false;
          _isVisibleWerkput = true;
          _isVisibleVlak = true;
          _isVisibleSpoor = true;
          _isVisibleCoupe = false;
          _isVisibleProfiel = false;
          _isVisibleStructuur = false;
          _isVisibleVondst = true;           
        });       
        loadVlak();        
        break;                  
    }
  }

  void updateController(String nameOfController){
    switch (nameOfController) {
      case 'name':
        _imageFind.name = nameController.text;
        break;
      // case 'purpose':
      //   _imageFind.purpose = purposeController.text;
      //   break;
      case 'project':
        _imageFind.project = projectController.text;
        break;
      case 'windDirection':
        _imageFind.windDirection = windDirectionController.text;
        break;
      case 'werkput':
        _imageFind.werkput = werkputController.text;
        break;
      case 'vlak':
        _imageFind.vlak = vlakController.text;
        break;
      case 'spoor':
        _imageFind.spoor = spoorController.text;
        break;
      case 'coupe':
        _imageFind.coupe = coupeController.text;
        break;                  
      case 'profiel':
        _imageFind.profiel = profielController.text;
        break;                  
      case 'structuur':
        _imageFind.structuur = structuurController.text;
        break;   
      case 'vondst':
        _imageFind.vondst = vondstController.text;
        break;                                 
    }
  }
    
  // Save data to database
  void _save() async {

    moveToLastScreen();

    //_imageFind.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (_imageFind.id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateImageFind(_imageFind);
    } else { // Case 2: Insert Operation
      _imageFind.uploaded = 0;
      result = await databaseHelper.insertImageFind(_imageFind);
    }
      
    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (_imageFind.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    //Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteImageFind(_imageFind.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showPhotoLibrary() async {

    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery
    );

    setState(() {
      _imageFind.name = pickedFile.path;      
      _save();     
    });

  }

  void _showCamera() async {

    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera, prefix: 'prefix')));
  
    setState(() {
      _imageFind.name = result[1];
      int _unixDateTime = result[0].millisecondsSinceEpoch;
      _imageFind.date = _unixDateTime ~/ 1000;
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

}

  typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);