import 'package:archeofind/models/project.dart';
import 'package:archeofind/services/database_project_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProjectDetail extends StatefulWidget{

  final String appBarTitle;
  final Project _project;

  ProjectDetail(this._project,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ProjectDetailState(this._project,this.appBarTitle);
  }
}

class ProjectDetailState extends State<ProjectDetail>{

  DatabaseProjectHelper databaseHelper=DatabaseProjectHelper();
  static var _types=['Opgraving1','Proefsleuf1'];
  Project _project;
  String appBarTitle;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  ProjectDetailState(this._project,this.appBarTitle);
  Widget build(BuildContext context) {
    TextStyle textStyle=Theme.of(context).textTheme.headline6;

    nameController.text=_project.name;
    addressController.text=_project.address;

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
                  value: getTypeAsString(_project.type),
                  onChanged: (valueSelectedByUser){
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updateTypeAsInt(valueSelectedByUser);
                    });
                  }
                ),            
              ),

              //Second Element
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
                    labelText: 'Naam',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
                ),
              ),

              //Third Element
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: addressController,
                  style: textStyle,
                  onChanged: (value){
                    debugPrint('Something changed in tiltle text field');
                    updateAddress();
                  },
                  decoration: InputDecoration(
                    labelText: 'Adres',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    )
                  ),
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
  }
  return type;
}

  void updateTypeAsInt(String value) {
  switch (value) {
    case 'Opgraving':
      _project.type = 1;
      break;
    case 'Proefsleuf':
      _project.type = 2;
      break;
  }
}

  void updateName(){
    _project.name = nameController.text;
  }

  void updateAddress(){
    _project.address = addressController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    //_project.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (_project.id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateProject(_project);
    } else { // Case 2: Insert Operation
      result = await databaseHelper.insertProject(_project);
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
    if (_project.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    // int result = await databaseHelper.deleteNote(note.id);
    // if (result != 0) {
    //   _showAlertDialog('Status', 'Note Deleted Successfully');
    // } else {
    //   _showAlertDialog('Status', 'Error Occured while Deleting Note');
    // }
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