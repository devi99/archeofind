import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DefaultsDetail extends StatefulWidget{
  
  DefaultsDetail();

  @override
  State<StatefulWidget> createState() {
    return DefaultsDetailState();
  }
}
    
class DefaultsDetailState extends State<DefaultsDetail>{

  String _mySelectionId;
  String _mySelectionName;

  final String url = "https://demo.archeofinds.lares.eu.meteorapp.com/api/v1/list/projects";

  List data = List(); //edited line

  Future<String> getProjects() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });

    return "Success";
  }

  TextEditingController projectController = TextEditingController();
  TextEditingController werkputController = TextEditingController();
  TextEditingController vlakController = TextEditingController();
  TextEditingController spoorController = TextEditingController();
  TextEditingController coupeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    getProjects();
    loadDefaults();
  }
  
  Widget build(BuildContext context) {
    
    TextStyle textStyle=Theme.of(context).textTheme.headline6;

    return Scaffold(
        appBar: AppBar(
          title: Text('Defaults'),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
          child: ListView(
            children: <Widget>[
              
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: new DropdownButton(
                  items: data.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['_id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelectionId = newVal;
                      int valIndex = data.indexWhere((f) => f['_id'] == newVal);
                      _mySelectionName = data[valIndex]["name"];
                    });
                    updateDefault('project');
                  },
                  style: textStyle,
                  value: _mySelectionId,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: werkputController,
                  style: textStyle,
                  onChanged: (value){
                    updateDefault('werkput');
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

              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: vlakController,
                  style: textStyle,
                  onChanged: (value){
                    updateDefault('vlak');
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
              
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: spoorController,
                  style: textStyle,
                  onChanged: (value){
                    updateDefault('spoor');
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
              
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: coupeController,
                  style: textStyle,
                  onChanged: (value){
                    updateDefault('coupe');
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

            ],
          ),
        ),
      );
  }
  
  void moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void loadDefaults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      werkputController.text = prefs.getString('werkput');
      projectController.text = prefs.getString('projectId');
      _mySelectionId = prefs.getString('projectId');
      vlakController.text = prefs.getString('vlak');
      spoorController.text = prefs.getString('spoor');
      coupeController.text = prefs.getString('coupe');
    });
  }

  void updateDefault(String _defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (_defaultValue){
      case 'werkput':
        setState(() {
          prefs.setString('werkput', werkputController.text);
        });
        break;
      case 'project':
        setState(() {
          prefs.setString('projectId', _mySelectionId);
          prefs.setString('projectName', _mySelectionName);
        });
        break;
      case 'vlak':
        setState(() {
          prefs.setString('vlak', vlakController.text);
        });
        break;
      case 'spoor':
        setState(() {
          prefs.setString('spoor', spoorController.text);
        });
        break;
      case 'coupe':
        setState(() {
          prefs.setString('coupe', coupeController.text);
        });
        break;                        
    }
  }
} 