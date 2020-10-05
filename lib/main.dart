// import 'package:archeofind/widgets/defaultsDetail.dart';
// import 'package:archeofind/widgets/imageFindList.dart';
// import 'package:archeofind/widgets/navdrawer.dart';
import 'package:archeofind/models/photos_library_api_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'presentation/tabs/pages/tabs_page.dart';
//import 'widgets/imageFindSyncedList.dart';

void main() {
  //runApp(MyApp());
    final apiModel = PhotosLibraryApiModel();
    apiModel.signInSilently();
    runApp(
      ScopedModel<PhotosLibraryApiModel>(
        model: apiModel,
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TabsPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}

/* 
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArcheoFind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: MyHomePage(title: 'ArcheoFind Home'),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'ArcheoFind Images'),
        '/sync': (context) => ImageFindSyncedList(),
        '/defaults': (context) => DefaultsDetail(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  
  int _selectedIndex = 0;
 
  void _onItemTapped(int tabIndex) {

    switch (tabIndex) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/defaults');
        break;
      case 2:
        Navigator.pushNamed(context, '/sync');
        break;
    }

    setState(() {
      _selectedIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {

     return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ImageFindList(0),
      bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Images'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                title: Text('Defaults'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                title: Text('Synced'),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          )      
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}
 */