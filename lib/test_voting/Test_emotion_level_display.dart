import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Colors/colors.dart';
import 'package:intl/intl.dart';

late User loggedinuser;
late String client;

class Test_Emotion_level_Display extends StatefulWidget {
  final String successid;

  Test_Emotion_level_Display({required this.successid});

  @override
  _Test_Emotion_level_DisplayState createState() =>
      _Test_Emotion_level_DisplayState();
}

class _Test_Emotion_level_DisplayState
    extends State<Test_Emotion_level_Display> {
  GlobalKey globalKey = new GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String selectedattempt;

  @override
  void initState() {
    super.initState();
    selectedattempt = widget.successid;
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

  ///timestamp
  String _formatDateAndTime(Timestamp timestamp) {
    try {
      final dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss'); // Customize format
      return dateFormat.format(dateTime);
    } catch (error) {
      print('Error converting timestamp: $error');
      return '';
    }
  }

  ///

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('test_emotions')
          .doc(selectedattempt)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;

          return

              ///material app begin
              MaterialApp(
            // Application name
            title: 'My Flutter App',
            debugShowCheckedModeBanner: false, // Remove debug banner
            home:

                ///should be cut out from here
                Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg_image.jpg'),
                  fit: BoxFit.cover, // Adjust fit as needed (cover, fill, etc.)
                ),
              ),
              child: Scaffold(
                appBar: AppBar(
                  // preferredSize: Size.fromHeight(kToolbarHeight + 20),
                  backgroundColor: AppColors.backgroundcolor,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  title: Text(
                    'Emotions  Graphs',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),

                  //centerTitle: true,
                ),
                body: Container(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Email :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),

                                  ///place the gemcode variable here
                                  Expanded(
                                    child: Text(
                                      '${data?['email']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            ///gem code end
                            ///gem name
                            ///gem name
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Date & Time :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),

                                  ///place the gem name variable here
                                  Expanded(
                                    child: Text(
                                      '${_formatDateAndTime(data?['times'])}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          // height: 6,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Fear :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),

                                  ///place the gemcode variable here
                                  Expanded(
                                    child: Text(
                                      '${data?['fear']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Anger :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),

                                  ///place the gemcode variable here
                                  Expanded(
                                    child: Text(
                                      '${data?['anger']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'sadness :',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),

                                  ///place the gemcode variable here
                                  Expanded(
                                    child: Text(
                                      '${data?['sadness']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22,
                                          height: 2,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            ///gem code
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          /// materialapp end
        }
        return CircularProgressIndicator();
      },
    );
  }
}
