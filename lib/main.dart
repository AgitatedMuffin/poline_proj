import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
      // 'camera': (context) => Camera(),
    },
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Constructor

  _MyHomePageState() {
    _camerInit();
    _getDirectories();
  }

  // Variables

  CameraController controller;
  List<CameraDescription> cameras;
  bool didEverythingWork = true;
  XFile imageFile;
  Directory _storageDirectory;
  bool state;

  Future<bool> _camerInit() async {
    try {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      return true;
    } catch (e) {
      return false;
    }
  }

// Functions
  _getDirectories() async {
    _storageDirectory = await getExternalStorageDirectory();
  }

  _cameraTakePictures() async {
    await controller.initialize();
    await controller.takePicture().then((value) => this.imageFile = value);
    this.imageFile.saveTo('${this._storageDirectory.path}/saved.jpg');
    print("All Done");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Bomba"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: RaisedButton(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.blue[300],
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          onPressed: () => {_cameraTakePictures()},
          child: Text(
            "Click me",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
