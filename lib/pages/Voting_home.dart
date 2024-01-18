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
