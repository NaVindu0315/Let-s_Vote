import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_vote/faceapi/compare-and-get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  ///my face api function
  void callCompareFacesAPI() async {
    try {
      final url = Uri.parse('http://localhost:3000/api/compareFaces');
      final requestBody = jsonEncode({
        "faceurl1":
            "https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_2.jpeg?alt=media&token=af022352-c7f2-4b21-9f4a-036bc857e6b0",
        "faceurl2":
            "https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_1.jpeg?alt=media&token=8525b947-ce30-471b-98d3-d2f2ed9afcdb"
      });

      final response = await http.post(url, body: requestBody);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData); // Print the response to the console
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  ///end

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
              /// to check my face api
              TextButton(onPressed: callCompareFacesAPI, child: Text('click')),

              ///my face api end
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
