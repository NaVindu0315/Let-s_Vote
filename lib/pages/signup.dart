import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

//void main() => runApp(gemifysign());
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
      'url': thisurl,
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
          iurl);

      if (newuser != null) {
        //Navigator.pushNamed(context, lgin.id);
      }
    } catch (e) {
      print(e);
    }
  }

  ///creating users end

  File? _image;
  Image myIcon = Image.asset('assets/ad.png');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      ///meke tyyna hamahuttama kapapan
      final ref = storage.ref().child('images/${DateTime.now().toString()}');
      final uploadTask = ref.putFile(File(pickedImage.path));
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      iurl = imageUrl;
      _image = File(pickedImage.path);

      setState(() {
        myIcon = Image.asset('pickedImage');
      });
    }
  }

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  late String _passwordError;

  void _validatePassword(pw2) {
    if (pw2 == pw) {
    } else {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Password doesn't match."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple.shade100,
        body: SingleChildScrollView(
          reverse: true,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple.shade200,
                          ),
                          onPressed: () {
                            //  Navigator.pushNamed(context, lgin.id);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
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
                  SizedBox(
                    height: 20.0,
                  ),

                  ////for the image adding button
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 135.0,
                      ),
                      InkWell(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent,
                          radius: 50.0,
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: /*Image(
                            image: AssetImage('images/ad.png'),
                          ),*/
                              _image == null
                                  ? Image.asset('images/ad.png')
                                  : Image.file(_image!),

                          /*IconButton(
                              icon: myIcon,
                              onPressed: null,
                            ),*/
                        ),
                      )
                    ],
                  ),
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
                      ),
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //email
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
//mobile
                  TextFormField(
                    onChanged: (value) {
                      mobile = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                      ),
                      labelText: 'Mobile',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //address
                  TextFormField(
                    onChanged: (value) {
                      address = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_city,
                      ),
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //birthday
                  TextFormField(
                    onChanged: (value) {
                      dob = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.calendar_today),
                      ),
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(),
                    ),
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
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
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
                      ),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //to add social media icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image(
                          image: AssetImage('images/f.png'),
                          height: 60.0,
                          width: 30.0,
                        ),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('images/g.png'),
                          height: 60.0,
                          width: 40.0,
                        ),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('images/t.png'),
                          height: 60.0,
                          width: 30.0,
                        ),
                      ),
                      Expanded(
                        child: Image(
                          image: AssetImage('images/m.png'),
                          height: 60.0,
                          width: 30.0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 32.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.deepPurple)),
                    onPressed: () {
                      if (pw == pw2) {
                        createuser();
                      } else {
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        AlertDialog alert = AlertDialog(
                          title: Text("Error"),
                          content: Text("Password doesn't match."),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }

                      //adduser(username, email, mobile, address, dob);
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
