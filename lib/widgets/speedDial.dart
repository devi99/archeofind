import 'package:archeofind/models/project.dart';
import 'package:archeofind/widgets/projectDetail.dart';
import 'package:flutter/material.dart';

class SpeedDial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SpeedDialState();
}

class SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget composeButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn1",
        onPressed: () {},
        tooltip: 'Compose',
        child: Icon(Icons.email),
        elevation: _shouldHaveElevation ? 6.0 : 0,
      ),
    );
  }

  Widget copyButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn2",
        onPressed: () async {
          bool result= await Navigator.push(context, MaterialPageRoute(builder: (context){
            return ProjectDetail(Project('',1234,2),'');
          }));
          if(result==true){
            //updateListView();
          }
        },
        tooltip: 'Add Note',
        child: Icon(Icons.content_copy),
        elevation: _shouldHaveElevation ? 6.0 : 0,
      ),
    );
  }

  Widget shareButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn3",
        onPressed: () {},
        tooltip: 'Share',
        child: Icon(Icons.share),
        elevation: _shouldHaveElevation ? 6.0 : 0,
      ),
    );
  }

  Widget menuButton() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btn4",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle menu',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
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
            _translateButton.value * 3.0,
            0.0,
          ),
          child: composeButton(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: copyButton(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: shareButton(),
        ),
        menuButton(),
      ],
    );
  }
}