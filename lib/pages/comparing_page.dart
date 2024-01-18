import 'package:flutter/material.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/Voting_home.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:quickalert/quickalert.dart';

late User loggedinuser;
late String client;

class Compare_page extends StatefulWidget {
  const Compare_page({Key? key}) : super(key: key);

  @override
  State<Compare_page> createState() => _Compare_pageState();
}

class _Compare_pageState extends State<Compare_page> {
  TextEditingController url1controller = TextEditingController();
  TextEditingController capturedimageurlcontroller = TextEditingController();
  late String url1img;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController loggedinusercontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();

  ///firebase storage
  final storage = FirebaseStorage.instance;
  CameraController? controller;
  late String imagePath = "";
  late String uploadedimageurl = "";

  ///capturing and storing function
  Future<void> uploadimage() async {
    final ref = storage
        .ref()
        .child('images/comparingimages/${DateTime.now().toString()}.jpg');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // Set content type explicitly

    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata along with the file
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    uploadedimageurl = imageUrl;
    capturedimageurlcontroller.text = uploadedimageurl;
    print(uploadedimageurl);
  }

  ///capturing and storing function end
  ///
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
                onConfirmBtnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => voting_home()),
                  );
                });
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

  ///to get the current user
  @override
  void initState() {
    super.initState();
    getcurrentuser();
    controller = CameraController(cameras![1], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void getcurrentuser() async {
    try {
      // final user = await _auth.currentUser();
      ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        client = loggedinuser.email!;

        ///i have to call the getdatafrm the function here and parse client as a parameter

        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(client)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return Scaffold(
                resizeToAvoidBottomInset: false,

                ///navigation bar eka iwrii
                ///drawer
                drawer: Drawer(
                  width: 300,
                  child: Container(
                    color: Color(0xDBD6E5FF), //color of list tiles
                    // Add a ListView to ensures the user can scroll
                    child: ListView(
                      // Remove if there are any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xFFD1D3FF), //color of drawer header
                          ),
                          accountName: Text(
                            '${data!['username']}',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                            ),
                          ),
                          accountEmail: Text(
                            client,
                            style:
                                TextStyle(color: Colors.indigo, fontSize: 17),
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('${data!['url']}'),
                          ),
                        ),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(Icons.home),
                            title: const Text('Home',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );
                            },
                          );
                        }),
                        //Cam page
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: const Text('Image Testing Page',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myapp()),
                              );
                            },
                          );
                        }),
                        //Announcement
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(Icons.face),
                            title: const Text('Face Comparing',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Compare_page()),
                              );
                            },
                          );
                        }),

                        ///voting home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(Icons.how_to_vote),
                            title: const Text('Voting Home',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => voting_home()),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                ///drawwe end
                appBar: AppBar(
                  backgroundColor: Color(0xFFA888EB),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  title: Text('Validate to Continue'),

                  //centerTitle: true,
                ),
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 100, // Set the desired height
                        decoration: BoxDecoration(
                          color: Color(0xFFA888EB),
                          borderRadius: BorderRadius.circular(
                              50), // Set the desired color
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Text(
                                '${data!['username']}',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170.0,
                            ),
                            Expanded(
                              child: CircleAvatar(
                                backgroundColor: Colors.purple,
                                minRadius: 70.5,
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                        //AssetImage('images/g.png'),
                                        NetworkImage('${data!['url']}')),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*   Text('${data!['url']}'),
                      Text(client),
                      ElevatedButton(
                          onPressed: () {
                            print(data!['url']);
                            print(client);
                            print(data!['username']);
                          },
                          child: Text('Test')),*/

                      ///adding camer preview
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
                      ///uploaded image link
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex:
                                2, // Set the width of the SizedBox to 300 pixels
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: capturedimageurlcontroller,
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

                      ///uploaded image link end
                      ///button
                      Row(
                        children: [
                          SizedBox(
                            width: 90.0,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                capturedimageurlcontroller.clear();
                                try {
                                  final image = await controller!.takePicture();
                                  setState(() {
                                    imagePath = image.path;
                                  });
                                  uploadimage();
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text("Capture image ")),
                          ElevatedButton(
                              onPressed: () {
                                capturedimageurlcontroller.clear();
                              },
                              child: Text('Clear'))
                        ],
                      ),
                      Builder(builder: (context) {
                        return ElevatedButton(
                            onPressed: () {
                              comaprewithurl(data!['url'], uploadedimageurl);
                              capturedimageurlcontroller.clear();
                            },
                            child: Text('Compare and Enter Face compare only'));
                      }),
                      ElevatedButton(
                          onPressed: () {},
                          child:
                              Text('Compare and Enter with Facial Expressions'))

                      ///button end

                      ///camer end
                    ],
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    ));
  }
}
