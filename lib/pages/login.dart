import 'package:flutter/material.dart';

import '../main.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(lgin());
}

class lgin extends StatefulWidget {
  @override
  State<lgin> createState() => _lginState();
}

class _lginState extends State<lgin> {
  ///controller for email and pwd
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pwcontroller = TextEditingController();

  ///controller end
  ///initialzing
  final _auth = FirebaseAuth.instance;
  late String email;
  late String pw;

  ///initializing end
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.purple.shade100,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Icon(Icons.ice_skating),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.purple.shade200,
                          ),
                          onPressed: () {},
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
                                /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => gemifysign()),
                                );*/
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
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'Lets Vote Login', // Add this new Text widget
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3F3D56),
                      ),
                    ),
                  ),
                  SizedBox(height: 5), // Add this SizedBox widget
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3F3D56),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 70,
                    width: 350, // Set the width of the SizedBox to 300 pixels
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: emailcontroller,
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
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 70,
                    width: 350, // Set the width of the SizedBox to 300 pixels
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: pwcontroller,
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
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New To Lets vote ? ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => gemifysign()),
                            );*/
                            // Add your sign up button onPressed code here
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              //decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          " Now ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 350,
                      height: 50,
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: ElevatedButton(
                        onPressed: () async {
                          emailcontroller.clear();
                          pwcontroller.clear();
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: pw);

                            if (user != null) {
                              /*  Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => dashboard()),
                              );*/
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //to add social media icons
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
