import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  final String prefix;
  TakePicturePage({@required this.camera, this.prefix});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.max);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context, String _prefix) async {
    try {
      await _initializeCameraControllerFuture;
      final dateNow = DateTime.now();
      final fileName = '$_prefix$dateNow.jpg';
      final path =
          join((await getTemporaryDirectory()).path, fileName);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _albumName = prefs.getString('project') ?? 'archeoFind';

      await _cameraController.takePicture(path);
      GallerySaver.saveImage(path, albumName: _albumName)
          .then((bool success) {
          });
      var arr = [dateNow, path];
      Navigator.pop(context,arr);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      SafeArea(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.camera),
              onPressed: () {
                _takePicture(context, widget.prefix);
              },
            ),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
