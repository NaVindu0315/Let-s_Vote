import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_vote/Colors/colors.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/lets_vote/employees/emp_dashboard.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';
import 'package:lets_vote/lets_vote/select_page.dart';
import 'package:lets_vote/pages/Group_Chat.dart';
import 'package:lets_vote/pages/Test/testgrapgh.dart';
import 'package:lets_vote/pages/addmincheck.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/management_dashboard.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import 'package:lets_vote/test_voting/Test_Emotion_List.dart';
import 'package:lets_vote/test_voting/Test_Enable_Disble.dart';
import 'package:lets_vote/test_voting/Test_Set_Graph_Values.dart';
import 'package:lets_vote/test_voting/test_election_set.dart';
import 'package:lets_vote/test_voting/test_email.dart';
import 'package:lets_vote/test_voting/test_vote_results.dart';
import 'package:lets_vote/test_voting/vote_home_2.dart';
import 'dart:io';

import 'Voting_home.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

import 'dart:io';
import 'package:get_ip_address/get_ip_address.dart';

import 'package:geolocator/geolocator.dart';

late User loggedinuser;
late String client;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController loggedinusercontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();

  ///for camera
  TextEditingController url1controller = TextEditingController();
  TextEditingController capturedimageurlcontroller = TextEditingController();
  late String url1img;

  ///camera end
  ///
  ///firebase storage
  final storage = FirebaseStorage.instance;
  CameraController? controller;
  late String imagePath = "";
  late String uploadedimageurl = "";
  DateTime now = DateTime.now();

  Color clickcolor = AppColors.backgroundcolor;

  ///capturing and storing function
  Future<void> uploadimage() async {
    //uploadedimageurl = "";
    capturedimageurlcontroller.clear();
    try {
      final image = await controller!.takePicture();
      setState(() {
        imagePath = image.path;
      });
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
      // print(uploadedimageurl);
    } catch (e) {
      print(e);
    }
  }

  ///capturing and storing function end
  ///new returing function
  Future<String> newupload() async {
    String uploadedImageUrl = ""; // Initialize the variable to an empty string
    try {
      capturedimageurlcontroller
          .clear(); // Clear the controller before uploading

      final image = await controller!.takePicture();
      setState(() {
        imagePath = image.path;
      });

      final ref = storage
          .ref()
          .child('images/comparingimages/${DateTime.now().toString()}.jpg');
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      final uploadTask = ref.putFile(File(imagePath), metadata);
      final snapshot = await uploadTask.whenComplete(() {});

      uploadedImageUrl = await snapshot.ref.getDownloadURL(); // Assign the URL

      return uploadedImageUrl; // Return the uploaded image URL
    } catch (e) {
      // Handle errors appropriately (e.g., display error messages)
      print(e);
      return ""; // Return an empty string in case of errors
    }
  }

/*
//thhis worked
  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
  }*/

  ///returning function end
  ///for the ip address

  ///to get the current user
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
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
    //_initNetworkInfo();
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
        print(loggedinuser.uid);

        final uidsave = _firestore.collection("uids").doc(loggedinuser.uid);

        uidsave.set({
          'uid': loggedinuser.uid,
          'email': loggedinuser.email,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> getIpAddress() async {
    try {
      var ipAddress = IpAddress(type: RequestType.json);
      var data = await ipAddress.getIpAddress();
      return data["ip"];
    } on IpAddressException catch (exception) {
      // Handle error and potentially return a default value or throw an error
      print(exception.message);
      // Replace with your error handling logic (e.g., return "")
      throw Exception("Failed to get IP address");
    }
  }

  ///this is the function to compare and get the results for face comparing without the captuing and storing
  ///funtion begin
  Future<dynamic> compareandexpression(
      String imageurl1, String imageurl2, String initalip) async {
    try {
      print('new upload');
      print(imageurl2);
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
            final url2 =
                Uri.parse('https://api-us.faceplusplus.com/facepp/v3/detect');
            final request2 = http.MultipartRequest('POST', url2);
            request2.fields['api_key'] = apiKey;
            request2.fields['api_secret'] = apiSecret;
            //  request.fields['return_landmark'] = '0';

            ///first testing gender &age
            request2.fields['return_attributes'] = 'emotion,eyestatus';
            request2.fields['image_url'] = imageurl2;
            try {
              final response2 = await request2.send();
              final responseData2 =
                  await response2.stream.transform(utf8.decoder).join();
              //print(responseData);
              ///to get the values for each attritbute seperately
              final parsedData =
                  jsonDecode(responseData2) as Map<String, dynamic>;
              final faces = parsedData['faces'] as List;
              if (faces.isNotEmpty) {
                final firstFace = faces[0];
                final attributes =
                    firstFace['attributes'] as Map<String, dynamic>;

                // Extract emotion values
                final anger = attributes['emotion']['anger'] as double;
                final fear = attributes['emotion']['fear'] as double;
                final sadness = attributes['emotion']['sadness'] as double;

                // Extract eye status values
                final leftEyeStatus = attributes['eyestatus']['left_eye_status']
                    as Map<String, dynamic>;
                final rightEyeStatus = attributes['eyestatus']
                    ['right_eye_status'] as Map<String, dynamic>;
                final leftNoGlassEyeOpen =
                    leftEyeStatus['no_glass_eye_open'] as double;
                final leftNormalGlassEyeOpen =
                    leftEyeStatus['normal_glass_eye_open'] as double;
                final rightNoGlassEyeOpen =
                    rightEyeStatus['no_glass_eye_open'] as double;
                final rightNormalGlassEyeOpen =
                    rightEyeStatus['normal_glass_eye_open'] as double;
                // Store the values as needed
                // Example:
                /* print('Anger: $anger');
          print('Fear: $fear');
          print('Sadness: $sadness');
          print('Left No Glass Eye Open: $leftNoGlassEyeOpen');
          print('Left Normal Glass Eye Open: $leftNormalGlassEyeOpen');
          print('Right No Glass Eye Open: $rightNoGlassEyeOpen');
          print('Right Normal Glass Eye Open: $rightNormalGlassEyeOpen');*/
                ///firestore upload failed attempt
                ///
                ///
                final position = await _geolocatorPlatform.getCurrentPosition();
                String ps = position.toString();
                String ip = await getIpAddress();
                String successid = "$client$now";
                final sucessattempt =
                    _firestore.collection("success").doc(successid);
                sucessattempt.set({
                  'successid': successid,
                  'profilepic': imageurl1,
                  'capturedimage': imageurl2,
                  'email': client,
                  'date & time': now,
                  'anger': anger,
                  'fear': fear,
                  'sadness': sadness,
                  'ip': ip,
                  'initip': initalip,
                  'location': ps,
                });

                /// to save data in emotion collection
                final emotiionsave =
                    _firestore.collection("test_emotions").doc(client);

                emotiionsave.set({
                  'anger': anger,
                  'sadness': fear,
                  'fear': sadness,
                  'email': client,
                  'times': now,
                }, SetOptions(merge: true));

                /// firestore upload end
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    title: 'Success',
                    text: 'Anger: $anger\n'
                        'Fear: $fear\n'
                        'Sadness: $sadness\n'
                        'Left No Glass Eye Open: $leftNoGlassEyeOpen\n'
                        'Left Normal Glass Eye Open: $leftNormalGlassEyeOpen\n'
                        'Right No Glass Eye Open: $rightNoGlassEyeOpen\n'
                        'Right Normal Glass Eye Open: $rightNormalGlassEyeOpen',
                    // autoCloseDuration: const Duration(seconds: 4),
                    showConfirmBtn: true,
                    onConfirmBtnTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => voting_home()),
                      );
                    });

                // You can store these values in variables or a data model as required
              }
            } catch (error) {
              print('Error during face detection: $error');
              return null;
            }

            ///end
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

            ///firestore upload failed attempt
            ///
            ///
            final position = await _geolocatorPlatform.getCurrentPosition();
            String ps = position.toString();
            String ip = await getIpAddress();
            String failedid = "$client$now";
            final failedattempt = _firestore.collection("failed").doc(failedid);
            failedattempt.set({
              'failedid': failedid,
              'profilepic': imageurl1,
              'capturedimage': imageurl2,
              'email': client,
              'date & time': now,
              'ip': ip,
              'initip': initalip,
              'location': ps,
            });

            /// firestore upload end
          }

          // Store the confidence value in a variable for further use
          double storedConfidence = confidence;

          // Use the storedConfidence variable as needed in your application
        } catch (error) {
          ///here the uploading shold be done
          ///firestore upload
          ///
          ///
          final position = await _geolocatorPlatform.getCurrentPosition();
          String ps = position.toString();
          String ip = await getIpAddress();
          String unknownid = "$client$now";
          final unknwerror =
              _firestore.collection("unknown Errors").doc(unknownid);
          unknwerror.set({
            'unknownid': unknownid,
            'profilepic': imageurl1,
            'capturedimage': imageurl2,
            'email': client,
            'date & time': now,
            'ip': ip,
            'initip': initalip,
            'location': ps,
          });
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Unknown Error',
            text: 'please Try Again',
            backgroundColor: Colors.black,
            titleColor: Colors.white,
            textColor: Colors.white,
          );

          /// firestore upload end
          print(now);
          print('Error parsing JSON response: $error');
        }

        ///end
        // Handle the successful response data
      } else {
        print(' Request failed with status: ${response.statusCode}');
        // Handle the error response
      }
    } catch (error) {
      print(' Error: $error');
      // Handle other errors
    }
  }

  /// end

  ///function end

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
                    color: AppColors.backgroundcolor, //color of list tiles
                    // Add a ListView to ensures the user can scroll
                    child: ListView(
                      // Remove if there are any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color:
                                AppColors.buttoncolor, //color of drawer header
                          ),
                          accountName: Text(
                            '${data!['username']}',
                            style: TextStyle(
                              color: AppColors.backgroundcolor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          accountEmail: Text(
                            client,
                            style: TextStyle(
                                color: AppColors.backgroundcolor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('${data!['url']}'),
                          ),
                        ),

                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            title: const Text('Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              /*   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );*/
                            },
                          );
                        }),

                        ///management dashboard
                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.manage_accounts,
                              color: Colors.white,
                            ),
                            title: const Text('Management dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Management_Dashboard()),
                              );
                            },
                          );
                        }),
                        //Cam page
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            title: const Text('Image Testing Page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
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
                            leading: Icon(
                              Icons.face,
                              color: Colors.white,
                            ),
                            title: const Text('Face Comparing Test',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
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
                            leading: Icon(
                              Icons.how_to_vote,
                              color: Colors.white,
                            ),
                            title: const Text('Voting Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => voting_home()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                            ),
                            title: const Text('Admin Change compare level',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => admincheck()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.auto_graph,
                              color: Colors.white,
                            ),
                            title: const Text('Graph',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => testgraph()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.how_to_vote,
                              color: Colors.white,
                            ),
                            title: const Text('New Voting HOme',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Vote_Home_2()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.verified_user,
                              color: Colors.white,
                            ),
                            title: const Text('Test Election Set',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => test_election_set()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.where_to_vote,
                              color: Colors.white,
                            ),
                            title: const Text('Test Election Results',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Test_vote_Results()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                            title: const Text('Test Email',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Test_Email()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.disabled_by_default,
                              color: Colors.white,
                            ),
                            title: const Text('Test Enable Disable',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Test_Enable_Disable()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.grade,
                              color: Colors.white,
                            ),
                            title: const Text('Test  Graph values set',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Test_Set_Graph_Values()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            title: const Text('Test Emotions List',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Test_Emotion_List()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.select_all,
                              color: Colors.white,
                            ),
                            title: const Text('Selection Page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Selection_page()),
                              );
                            },
                          );
                        }),

                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.dashboard,
                              color: Colors.white,
                            ),
                            title: const Text('Employee Dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Emp_Dashboard()),
                              );
                            },
                          );
                        }),
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.dashboard,
                              color: Colors.white,
                            ),
                            title: const Text('management Dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Mng_Dashboard()),
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
                  // preferredSize: Size.fromHeight(kToolbarHeight + 20),
                  backgroundColor: AppColors.backgroundcolor,

                  title: Text(
                    'Welcome To Lets Vote',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),

                  //centerTitle: true,
                ),
                body: Stack(children: [
                  // Background image container
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/bg_image.jpg'), // Replace with your image path
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 32.0,
                        ),
                        CircleAvatar(
                            backgroundColor: AppColors.backgroundcolor,
                            minRadius: 70.5,
                            child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    //AssetImage('images/g.png'),
                                    NetworkImage('${data!['url']}'))),

                        ///main
                        Column(
                          //first row
                          children: [
                            ///Row for the text field
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  '${data!['username']}',
                                  style: TextStyle(
                                      color: AppColors.backgroundcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                Spacer()
                              ],
                            ),

                            ///row for the designation
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Designation',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                Spacer()
                              ],
                            ),

                            ///row for the designation end
                            SizedBox(
                              height: 40.0,
                            ),

                            ///row end
                            Row(
                              children: [
                                ///for the employee management
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Management_Dashboard()),
                                    );
                                  },
                                  child: Container(
                                      height: 120.0,
                                      child: Card(
                                        color: AppColors.backgroundcolor,
                                        child: Image.asset('assets/empmg.png'),
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),

                                ///for the camera preview
                                /*      Expanded(
                                  child: Container(
                                    width: 150,
                                    height: 120,
                                    child: AspectRatio(
                                      aspectRatio:
                                          controller!.value.aspectRatio,
                                      child: CameraPreview(controller!),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),

                            ///second row
                            Row(
                              children: [
                                ///to compare the face and navigate to the votig home
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.mediumImpact();
                                    String up = await newupload();
                                    // print(up);
                                    /*  capturedimageurlcontroller.clear();
                                    uploadimage();*/

                                    await compareandexpression(
                                        data!['url'], up, data!['initip']);

                                    //print('profile pic');
                                    //  print(data!['url']);
                                    //print('now image');
                                    //print(uploadedimageurl);
                                  },
                                  /*  onTap: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // Prevent user from dismissing while loading
                                      builder: (context) => Center(
                                        child: SpinKitSpinningCircle(
                                          color: Colors
                                              .white, // Customize loading indicator color
                                          size: 50.0,
                                          controller: AnimationController(
                                              vsync: this,
                                              duration: const Duration(
                                                  milliseconds:
                                                      1200)), // Adjust size as needed
                                        ),
                                      ),
                                    );

                                    try {
                                      String up = await newupload();

                                      // Additional actions (if needed)

                                      await compareandexpression(
                                          data!['url'], up);
                                    } catch (error) {
                                      // Handle errors gracefully
                                      print(error);
                                      // Show an error message or retry option
                                    } finally {
                                      // Always close the loading dialog
                                      Navigator.pop(context);
                                    }
                                  },*/
                                  child: Container(
                                      height: 120.0,
                                      child: Card(
                                        color: AppColors.backgroundcolor,
                                        child: Image.asset('assets/vote.png'),
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                              ],
                            ),

                            ///third row
                            Row(
                              children: [
                                //first box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () async {
                                    final position = await _geolocatorPlatform
                                        .getCurrentPosition();
                                    print(position);
                                    //printIps();
                                    //   print(_connectionStatus);
                                  },
                                  child: Container(
                                      height: 120.0,
                                      child: Card(
                                        color: AppColors.backgroundcolor,
                                        child: Image.asset('assets/create.png'),
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                                //second box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () async {
                                    print('fuck');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GroupChat()),
                                    );
                                  },
                                  child: Container(
                                      height: 120.0,
                                      child: Card(
                                        color: AppColors.backgroundcolor,
                                        child: Image.asset('assets/post.png'),
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
              );
            }
            return CircularProgressIndicator();
          }),
    ));
  }
}
