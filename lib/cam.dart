import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

List<CameraDescription>? cameras;

class myapp extends StatelessWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//List<CameraDescription>? cameras;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///firebase storage
  final storage = FirebaseStorage.instance;
  CameraController? controller;
  late String imagePath = "";
  late String iurl = "";

  ///firebase upload function begin
  /*
  Future<void> upld() async {
    final ref = storage.ref().child('images/${DateTime.now().toString()}.jpg');
    final uploadTask = ref.putFile(File(imagePath));
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    iurl = imageUrl;
  }
*/
  Future<void> upld() async {
    final ref = storage.ref().child('images/${DateTime.now().toString()}.jpg');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // Set content type explicitly

    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata along with the file
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    iurl = imageUrl;
  }

  ///new
  /*Future<void> upld() async {
    final ref = storage.ref().child('images/${DateTime.now().toString()}.jpg');
    final metadata = Metadata()
      ..contentType =
          'image/jpeg'; // Set content type to 'image/jpeg' for JPEG images
    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata with content type
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    iurl = imageUrl;
  }*/

  /// frebase uploading function end
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras![1], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              /* Container(
                width: 200,
                height: 200,
                child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: CameraPreview(controller!),
                ),
              ),*/

              TextButton(
                  onPressed: () async {
                    try {
                      final image = await controller!.takePicture();
                      setState(() {
                        imagePath = image.path;
                      });
                      upld();
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Take Photo")),

              ///begin
              /*   if (imagePath != "")
                Container(
                    width: 300,
                    height: 300,
                    child: Image.file(
                      File(imagePath),
                    )),
*/
              ///end
              SizedBox(
                height: 10,
              ),
              Text('$imagePath & $iurl')
            ],
          ),
        ),
      ),
    );
  }
}
