import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:quickalert/quickalert.dart';

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
  TextEditingController url1controller = TextEditingController();
  TextEditingController url2controller = TextEditingController();
  TextEditingController uploadedurl1controller = TextEditingController();

  TextEditingController uploadedurl2controller = TextEditingController();

  late String url1img;
  late String url2img;

  ///firebase storage
  final storage = FirebaseStorage.instance;
  CameraController? controller;
  late String imagePath = "";
  late String uploadedurl1 = "";
  late String uploadedurl2 = "";

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
  ///to capture the first photo
  Future<void> upload1() async {
    final ref = storage.ref().child('images/${DateTime.now().toString()}.jpg');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // Set content type explicitly

    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata along with the file
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    uploadedurl1 = imageUrl;
    uploadedurl1controller.text = uploadedurl1;
    print(uploadedurl1);
  }

  ///first photo capturing end
  ///second phot capturing
  Future<void> upload2() async {
    final ref = storage.ref().child('images/${DateTime.now().toString()}.jpg');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // Set content type explicitly

    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata along with the file
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    uploadedurl2 = imageUrl;
    uploadedurl2controller.text = uploadedurl2;
    print(uploadedurl2);
  }

  ///second photo capturing end

  ///faceapi try

  Future<void> compareFaces() async {
    try {
      // Replace with your actual Face++ API keys
      final apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
      final apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';

      // Replace with the actual face tokens
      final imageurl1 =
          'https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_2.jpeg?alt=media&token=af022352-c7f2-4b21-9f4a-036bc857e6b0';
      final imageurl2 =
          'https://firebasestorage.googleapis.com/v0/b/navindu-store.appspot.com/o/face-api%20images%2Fnngi_1.jpeg?alt=media&token=8525b947-ce30-471b-98d3-d2f2ed9afcdb';

      final url =
          Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');
      final request = http.MultipartRequest('POST', url);

      request.fields['api_key'] = apiKey;
      request.fields['api_secret'] = apiSecret;
      request.fields['image_url1'] = imageurl1;
      request.fields['image_url2'] = imageurl2;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        //print(responseData);
        ///trying to get the confidence value extracted
        try {
          final responseJson = jsonDecode(responseData) as Map<String, dynamic>;
          final confidence = responseJson['confidence'] as double;
          print('Confidence: $confidence');

          // Store the confidence value in a variable for further use
          double storedConfidence = confidence;

          // Use the storedConfidence variable as needed in your application
        } catch (error) {
          print('Error parsing JSON response: $error');
        }

        ///end
        // Handle the successful response data
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Handle the error response
      }
    } catch (error) {
      print('Error: $error');
      // Handle other errors
    }
  }

  ///face api end

  /// function to paste urls and then compare
  Future<void> comaprewithurl(String imageurl1, String imageurl2) async {
    try {
      // Replace with your actual Face++ API keys
      final apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
      final apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';

      final url =
          Uri.parse('https://api-us.faceplusplus.com/facepp/v3/compare');
      final request = http.MultipartRequest('POST', url);

      request.fields['api_key'] = apiKey;
      request.fields['api_secret'] = apiSecret;
      request.fields['image_url1'] = imageurl1;
      request.fields['image_url2'] = imageurl2;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        //print(responseData);
        ///trying to get the confidence value extracted
        try {
          final responseJson = jsonDecode(responseData) as Map<String, dynamic>;
          final confidence = responseJson['confidence'] as double;
          print('Confidence: $confidence');
          if (confidence > 85.00) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Same Person',
              text: 'Same Person! confidence =  $confidence',
              autoCloseDuration: const Duration(seconds: 4),
              showConfirmBtn: false,
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Not the same person',
              text: 'person doesnt match confidence:  $confidence',
              backgroundColor: Colors.black,
              titleColor: Colors.white,
              textColor: Colors.white,
            );
          }

          // Store the confidence value in a variable for further use
          double storedConfidence = confidence;

          // Use the storedConfidence variable as needed in your application
        } catch (error) {
          print('Error parsing JSON response: $error');
        }

        ///end
        // Handle the successful response data
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Handle the error response
      }
    } catch (error) {
      print('Error: $error');
      // Handle other errors
    }
  }

  /// url paste compare end
  ///controller
  ///
  ///

  /// frebase uploading function end
  ///
  /// function to check the smile of the captured phot
  Future<dynamic> getfacialdetials(String img1url) async {
    try {
      ///apikey and secret
      final apiKey = 'Ihp7UgfV3b7KH-aAyQl5EiStwGX5ch1B';
      final apiSecret = '_kjlV-L5QjSYp9vQVP9a4VHosyehnbJ7';

      ///
      final url = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/detect');
      final request = http.MultipartRequest('POST', url);
    } catch (error) {
      print('Error: $error');
      // Handle other errors
    }
    final url = Uri.parse('https://api-us.faceplusplus.com/facepp/v3/detect');
    final request = http.MultipartRequest('POST', url);
  }

  /// end of smile checking function
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),

                ///camera prview
                Container(
                  width: 200,
                  height: 200,
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: CameraPreview(controller!),
                  ),
                ),

                ///camera preview end

                ///textfield to display the upload image url 1
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2, // Set the width of the SizedBox to 300 pixels
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: uploadedurl1controller,
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Image url1',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ///end uploaded textfiled 1
                ///second text field
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2, // Set the width of the SizedBox to 300 pixels
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: uploadedurl2controller,
                          readOnly: true,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Image url2',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ///second text field end
                Row(
                  children: [
                    SizedBox(
                      width: 60.0,
                    ),
                    TextButton(
                        onPressed: () async {
                          uploadedurl1controller.clear();
                          try {
                            final image = await controller!.takePicture();
                            setState(() {
                              imagePath = image.path;
                            });
                            upload1();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("Capture image 1")),
                    TextButton(
                        onPressed: () async {
                          uploadedurl2controller.clear();
                          try {
                            final image = await controller!.takePicture();
                            setState(() {
                              imagePath = image.path;
                            });
                            upload2();
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("Capture image 2")),
                  ],
                ),

                ///button row end
                ///this button call the compare function check the captured photos are working
                TextButton(
                    onPressed: () async {
                      comaprewithurl(uploadedurl1, uploadedurl2);
                      uploadedurl1controller.clear();
                      uploadedurl2controller.clear();
                    },
                    child: Text('Compare the captured images')),

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
                //Text('$imagePath & $iurl')
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2, // Set the width of the SizedBox to 300 pixels
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: url1controller,
                          readOnly: false,
                          enabled: true,
                          onChanged: (value) {
                            url1img = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'url1',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ///url2 textfield
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2, // Set the width of the SizedBox to 300 pixels
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: url2controller,
                          readOnly: false,
                          enabled: true,
                          onChanged: (value) {
                            url2img = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'url2',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                ///url 2 end
                ///button row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        // onPressed: () => comaprewithurl(url1img, url2img),
                        onPressed: () async {
                          comaprewithurl(url1img, url2img);
                          url1controller.clear();
                          url2controller.clear();
                        },
                        child: Text('compare two images'))
                  ],
                ),

                ///button end
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///now working
