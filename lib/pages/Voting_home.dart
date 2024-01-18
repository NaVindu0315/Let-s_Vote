import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User loggedinuser;
late String client;

class voting_home extends StatefulWidget {
  const voting_home({Key? key}) : super(key: key);

  @override
  State<voting_home> createState() => _voting_homeState();
}

class _voting_homeState extends State<voting_home> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  ///to get the current user
  @override
  void initState() {
    super.initState();
    getcurrentuser();
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
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [Text('Lets vote now')],
        ),
      ),
    );
  }
}
