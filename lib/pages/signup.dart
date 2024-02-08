import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

///for camera
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lets_vote/pages/login.dart';
import '../cam.dart';
import 'package:quickalert/quickalert.dart';
import 'package:lets_vote/Colors/colors.dart';

void main() {
  runApp(signup());
}

class signup extends StatefulWidget {
  static String id = 'signup';

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  ///declaring variables
  late String username;
  late String email;
  late String mobile;
  late String address;
  late String dob;
  late String pw;
  late String pw2;
  late String iurl;

  ///variales end
  ///
  /// for the image capturing
  TextEditingController propicurlcontroller = TextEditingController();

  CameraController? controller;
  late String imagePath = "";
  late String propicurl = "";

  /// image cpaturing end
  /// to capture the image and get the url
  Future<void> propicupload() async {
    final ref =
        storage.ref().child('images/propics/${DateTime.now().toString()}.jpg');
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // Set content type explicitly

    final uploadTask = ref.putFile(
        File(imagePath), metadata); // Pass metadata along with the file
    final snapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await snapshot.ref.getDownloadURL();
    propicurl = imageUrl;
    propicurlcontroller.text = propicurl;
    print(propicurl);
  }

  ///capture and retrieving url end

  ///function to set data to userfield
  Future<void> adduser(
    String username,
    String email,
    String mobile,
    String address,
    String dob,

    ///meka cut krpn
    String thisurl,
  ) async {
    // await _firestore.collection('userdetails').add({'email': email, 'pw': pw});
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'username': username,
      'email': email,
      'mobile': mobile,
      'address': address,
      'dob': dob,

      ///meka cut krpn
      'url': propicurl,
    });
  }

  ///creating users function begin
  void createuser() async {
    try {
      final newuser = await _auth.createUserWithEmailAndPassword(
          email: email, password: pw);

      ///call the add details function here
      adduser(
          username,
          email,
          mobile,
          address,
          dob,

          ///meka cut krpn
          propicurl);

      if (newuser != null) {
        //Navigator.pushNamed(context, lgin.id);
      }
    } catch (e) {
      print(e);
    }
  }

  ///creating users end
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController adrscontroller = TextEditingController();
  TextEditingController bdaycontroller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.backgroundcolor,
        body: SingleChildScrollView(
          reverse: true,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ///camera prview
                  Container(
                    width: 100,
                    height: 150,
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: CameraPreview(controller!),
                    ),
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            propicurlcontroller.clear();
                            try {
                              final image = await controller!.takePicture();
                              setState(() {
                                imagePath = image.path;
                              });
                              propicupload();
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            "Capture",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                      SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            propicurlcontroller.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ))
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //

                      ////for the image adding button

                      ////image adding button end

                      //// sign up and login labels

                      ////sign up and login labels end

                      SizedBox(
                        height: 15.0,
                      ),
                      //username
                      TextFormField(
                        onChanged: (value) {
                          username = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color:
                                Colors.white, // Set prefix icon color to white
                          ),
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Enter your username',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color to white with opacity for better visibility
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width for better feedback
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      //email
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color:
                                Colors.white, // set prefix icon color to white
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // set label text color to white
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // set hint text color to white with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // set typed text color to white
                      ),

                      //mobile
                      TextFormField(
                        onChanged: (value) {
                          mobile = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color:
                                Colors.white, // Set prefix icon color to white
                          ),
                          labelText: 'Mobile',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Enter your mobile number',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color to white with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      //address
                      TextFormField(
                        onChanged: (value) {
                          address = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                            color:
                                Colors.white, // Set prefix icon color to white
                          ),
                          labelText: 'Address',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Enter your address',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      //birthday

                      TextFormField(
                        onChanged: (value) {
                          dob = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors
                                  .white, // Set prefix icon color to white
                            ),
                          ),
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Select your date of birth',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      //url
                      TextFormField(
                        controller: propicurlcontroller,
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.web,
                              color: Colors
                                  .white, // Set prefix icon color to white
                            ),
                          ),
                          labelText: 'url',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintStyle: const TextStyle(
                              color:
                                  Colors.white), // Remove hint since read-only
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width (not applicable)
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors
                                .white), // Set typed text color to white (not applicable)
                      ),

                      //password
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) {
                          pw = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.key,
                            color:
                                Colors.white, // Set prefix icon color to white
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      //confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        onChanged: (value) {
                          pw2 = value;
                          //_validatePassword(value);
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.key,
                            color:
                                Colors.white, // Set prefix icon color to white
                          ),
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                              color: Colors
                                  .white), // Set label text color to white
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.6)), // Set hint text color with opacity
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Set border color to white
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent,
                                width:
                                    2.0), // Set focused border color and width
                          ),
                        ),
                        style: const TextStyle(
                            color:
                                Colors.white), // Set typed text color to white
                      ),

                      SizedBox(
                        height: 20.0,
                      ),
                      //to add social media icons

                      SizedBox(
                        height: 32.0,
                      ),
                      Builder(builder: (context) {
                        return ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black)),
                          onPressed: () {
                            if (pw == pw2) {
                              createuser();
                              /* adduser(username, email, mobile, address, dob,
                                    propicurl);*/
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.success,
                                  title: 'Signed Up',
                                  text:
                                      '$username Your account created Succesfully  ',
                                  onConfirmBtnTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => lgin()),
                                    );
                                  });

                              usernamecontroller.clear();
                              emailcontroller.clear();
                              mobilecontroller.clear();
                              adrscontroller.clear();
                              bdaycontroller.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            } else {
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                              //alert
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: 'Passwords doesnt match',
                                text: 'Please enter password again ',
                                backgroundColor: Colors.black,
                                titleColor: Colors.white,
                                textColor: Colors.white,
                                autoCloseDuration: const Duration(seconds: 4),
                                showConfirmBtn: false,
                              );
                            }
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Builder(builder: (context) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple.shade200,
                                ),
                                onPressed: () {
                                  //  Navigator.pushNamed(context, lgin.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => lgin()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.purple.shade200,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, signup.id);
                                  },
                                  child: Text(
                                    'SIGNUP',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
