import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:lets_vote/pages/welcome%20screen.dart';

import '../Colors/colors.dart';

late User loggedinuser;
late String client;

class Test_Set_Graph_Values extends StatefulWidget {
  const Test_Set_Graph_Values({Key? key}) : super(key: key);

  @override
  State<Test_Set_Graph_Values> createState() => _Test_Set_Graph_ValuesState();
}

class _Test_Set_Graph_ValuesState extends State<Test_Set_Graph_Values> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  DateTime now = DateTime.now();
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

  Future<void> setdata() async {
    final unknwerror = _firestore.collection("test_emotions").doc(client);

    unknwerror.set({
      'anger': 45.5,
      'sadness': 80.0,
      'fear': 60.0,
      'email': client,
      'times': now,
    }, SetOptions(merge: true));
  }

  Future<void> updatedata() async {
    final emotiionsave = _firestore.collection("test_emotions").doc(client);

    emotiionsave.set({
      'anger': 90.5,
      'sadness': 40.0,
      'fear': 10.0,
      'email': client,
      'times': now,
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashBoard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Test Graph value set',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Spacer(),

              ///vote count display row
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        setdata();
                      },
                      child: Text('set')),
                  // Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        updatedata();
                      },
                      child: Text('Update')),
                  // Text('data'),
                  Spacer(),
                ],
              ),

              /// vote count display row end
              SizedBox(
                height: 10.0,
              ),

              ///row to display name of the candidates

              ///candidate display row end

              Spacer(),

              ///row for the buttons
              Row(
                children: [
                  Spacer(),
                  Text('data'),
                  // Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  // ElevatedButton(onPressed: () {}, child: Text('Send')),
                  Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  Text('data'),
                  // Text('data'),
                  Spacer(),
                ],
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
