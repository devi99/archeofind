import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultsDetail extends StatefulWidget{
  
  DefaultsDetail();

  @override
  State<StatefulWidget> createState() {
    return DefaultsDetailState();
  }
}
    
class DefaultsDetailState extends State<DefaultsDetail>{

  TextEditingController projectController = TextEditingController();
  TextEditingController werkputController = TextEditingController();
  TextEditingController vlakController = TextEditingController();
  TextEditingController spoorController = TextEditingController();
  TextEditingController coupeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    loadDefaults();
  }
  
  Widget build(BuildContext context) {
    
    TextStyle textStyle=Theme.of(context).textTheme.headline6;

    return new WillPopScope(
      onWillPop: () async {
        return true;
      }, child: Scaffold(
        appBar: AppBar(
          title: Text('Defaults'),
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
              Padding(
                padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                  controller: projectController,
                  style: textStyle,
                  onChanged: (value){
                    updateDefault('project');
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
      projectController.text = prefs.getString('project');
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
          prefs.setString('project', projectController.text);
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