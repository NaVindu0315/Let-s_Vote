import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_vote/Colors/colors.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/Group_Chat.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/management_dashboard.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
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

class admincheck extends StatefulWidget {
  const admincheck({Key? key}) : super(key: key);

  @override
  State<admincheck> createState() => _admincheckState();
}

class _admincheckState extends State<admincheck> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController loggedinusercontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();

  ///for camera
  TextEditingController url1controller = TextEditingController();
  TextEditingController capturedimageurlcontroller = TextEditingController();
  late String url1img;
  String? videoPath;

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

  ///for recording

  onPressedStart() async {
    if (controller!.value.isRecordingVideo) {
      return;
    }

    try {
      await controller!.startVideoRecording();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  onPressedStop() async {
    if (!controller!.value.isRecordingVideo) {
      return;
    }

    try {
      final video = await controller!.stopVideoRecording();
      setState(() {
        videoPath = video.path;
      });
      print(videoPath);

      // Upload the video to Firebase Storage
      await vupld();
    } catch (e) {
      print(e);
    }
  }

  Future<void> vupld() async {
    if (videoPath == null) return;

    final ref = storage.ref().child('videos/${DateTime.now().toString()}.mp4');
    final uploadTask = ref.putFile(
      File(videoPath!),
      SettableMetadata(
        contentType: 'video/mp4',
      ),
    );

    final snapshot = await uploadTask.whenComplete(() {});
    final videoUrl = await snapshot.ref.getDownloadURL();
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: '$videoUrl',
      autoCloseDuration: const Duration(seconds: 4),
      showConfirmBtn: false,
    );
    /*  final vvid = "$client$now";
    final vattempt = _firestore.collection("attemptvideos").doc(vvid);
    vattempt.set({
      'linkk': videoUrl,
    });*/

    print(videoUrl);
  }

  /// recording end
  ///data fetching

  late DatabaseReference _databaseReference;

  double level = 0.0;

  FirebaseDatabase database = FirebaseDatabase.instance;

  late double setlvl;

  TextEditingController lvlcontroller = TextEditingController();

  late DatabaseReference lvlsetref = FirebaseDatabase.instance.ref();

  Future<void> levelset(double lvl) async {
    await _databaseReference.set(lvl);
  }

  ///data fecthing and setting end
  ///
  late DatabaseReference _electionreference;
  int election = 5;

  Future<void> setelection1() async {
    await _electionreference.set(1);

    /* _electionreference.onDisconnect().set(8).then((_) {
      Future.delayed(Duration(hours: 2), () {
        database.goOffline();
      });
    });*/
  }

  Future<void> setauto0() async {
    await _electionreference.set(1);

    _electionreference.onDisconnect().set(0).then((_) {
      Future.delayed(Duration(hours: 1), () {
        database.goOffline();
      });
    });
  }

  Future<void> setschedule() async {
    // await _electionreference.set(1);

    _electionreference.onDisconnect().set(1).then((_) {
      Future.delayed(Duration(hours: 1), () {
        database.goOffline();
      });
    });

    _electionreference.onDisconnect().set(0).then((_) {
      Future.delayed(Duration(hours: 2), () {
        database.goOffline();
      });
    });
  }

  Future<void> setelection0() async {
    await _electionreference.set(0);
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();

    /// Initialize the FirebaseDatabase reference
    _databaseReference = FirebaseDatabase.instance.reference().child('level');
    _electionreference =
        FirebaseDatabase.instance.reference().child('election');

    controller = CameraController(cameras![1], ResolutionPreset.medium);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    //_initNetworkInfo();
    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          level = snapshot.value as double;
        });
      }
    });

    _electionreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          election = snapshot.value as int;
        });
      }
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
  Future<dynamic> comparewithlevelfunction(
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
          if (confidence > level) {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );
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
                      ],
                    ),
                  ),
                ),

                ///drawwe end
                appBar: AppBar(
                  // preferredSize: Size.fromHeight(kToolbarHeight + 20),
                  backgroundColor: AppColors.backgroundcolor,

                  title: Text(
                    ' Change similarity Level',
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
                                  'Admin',
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
                              height: 10.0,
                            ),

                            ///row end
                            Row(
                              children: [
                                ///for the employee management
                                ///here
                                /* Expanded(
                                  child: Row(
                                    children: [],
                                  ),
                                    ),*/
                                SizedBox(
                                  height: 70,
                                  width:
                                      350, // Set the width of the SizedBox to 300 pixels
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller: lvlcontroller,
                                      onChanged: (value) {
                                        //email = value;
                                        setlvl = double.parse(value);
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.settings,
                                        ),
                                        labelText: 'Set new Value',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),

                                ///end

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
                            ElevatedButton(
                                onPressed: () {
                                  lvlcontroller.clear();
                                  levelset(setlvl);
                                  print(setlvl);
                                },
                                child: Text('Set New Value')),

                            ///second row
                            Row(
                              children: [
                                ///to compare the face and navigate to the votig home
                                Expanded(
                                    child: GestureDetector(
                                  onTap: election == 1
                                      ?

                                      ///this works
                                      () async {
                                          HapticFeedback.mediumImpact();
                                          String up = await newupload();
                                          // print(up);
                                          /*  capturedimageurlcontroller.clear();
                                    uploadimage();*/

                                          await comparewithlevelfunction(
                                              data!['url'],
                                              up,
                                              data!['initip']);

                                          //print('profile pic');
                                          //  print(data!['url']);
                                          //print('now image');
                                          //print(uploadedimageurl);
                                        }
                                      :

                                      ///abive is the right one
                                      () {
                                          QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.info,
                                            text: 'No Elections Right now',
                                            autoCloseDuration:
                                                const Duration(seconds: 4),
                                            showConfirmBtn: false,
                                          );
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
                                      height: 100.0,
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
                            Row(
                              children: [
                                //first box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sucs_Attempt_list()),
                                        );*/
                                    //  onPressedStart();
                                    setelection1();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Enable Voting',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sucs_Attempt_list()),
                                        );*/
                                    //  onPressedStart();
                                    // setelection1();
                                    setauto0();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Auto Disble',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sucs_Attempt_list()),
                                        );*/
                                    //  onPressedStart();
                                    //  setelection1();
                                    setschedule();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Schedule ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
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
                                  onTap: () {
                                    //onPressedStop();
                                    setelection0();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Disable Voting',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0),
                                          ),
                                          Spacer(),
                                        ],
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
                                  onTap: () {
                                    /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sucs_Attempt_list()),
                                        );*/
                                  },
                                  child: Container(
                                      height: 90.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            '$level\n'
                                            '$election',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DashBoard()),
                                    );
                                  },
                                  child: Container(
                                      height: 90.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Default Home',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
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
                            Row(
                              children: [
                                //first box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  sucs_Attempt_list()),
                                        );*/
                                    onPressedStart();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Start Recording',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
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
                                  onTap: () {
                                    onPressedStop();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 30.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Stop Recording',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                          Spacer(),
                                        ],
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
