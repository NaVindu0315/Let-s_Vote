import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_vote/Colors/colors.dart';
import 'package:lets_vote/cam.dart';
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

class Emp_Dashboard extends StatefulWidget {
  const Emp_Dashboard({Key? key}) : super(key: key);

  @override
  State<Emp_Dashboard> createState() => _Emp_DashboardState();
}

class _Emp_DashboardState extends State<Emp_Dashboard> {
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
  ///
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

  ///returning function end
  ///for the ip address

  ///to get the current user
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  late DatabaseReference _databaseReference;

  double level = 0.0;

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
    _databaseReference = FirebaseDatabase.instance.reference().child('level');

    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          level = snapshot.value as double;
          print(level);
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('data'),
          ],
        ),
      ),
    );
  }
}
