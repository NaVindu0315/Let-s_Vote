import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../Colors/colors.dart';
import 'package:intl/intl.dart';

late User loggedinuser;
late String client;

class Detailed_other_error extends StatefulWidget {
  final String unknownid;

  Detailed_other_error({required this.unknownid});

  @override
  _Detailed_other_errorState createState() => _Detailed_other_errorState();
}

class _Detailed_other_errorState extends State<Detailed_other_error> {
  GlobalKey globalKey = new GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String selectedattempt;

  @override
  void initState() {
    super.initState();
    selectedattempt = widget.unknownid;
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
          .collection('unknown Errors')
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
                    'Attempt Details',
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
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              children: [
                                ///Gem picture
                                ///circle avatar
                                Spacer(),
                                CircleAvatar(
                                    backgroundColor: AppColors.backgroundcolor,
                                    minRadius: 73,
                                    child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage:
                                            //AssetImage('images/g.png'),
                                            NetworkImage(
                                                '${data!['profilepic']}'))),
                                Spacer(),
                                CircleAvatar(
                                    backgroundColor: Colors.red,
                                    minRadius: 73,
                                    child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage:
                                            //AssetImage('images/g.png'),
                                            NetworkImage(
                                                '${data!['capturedimage']}'))),
                                Spacer(),

                                ///end
                                /* Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    height: 200,
                                    width: double.infinity,
                                    color: Color(0xDBD6EFFF),
                                    child: Image(
                                      image: NetworkImage('${data!['profilepic']}'),
                                    ),
                                  ),
                                ),*/

                                ///gem pic end
                                ///qr
                                /*   Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 20),
                                    height: 200,
                                    width: double.infinity,
                                    color: Color(0xDBD6EFFF),
                                    child: Image(
                                      image:
                                          NetworkImage('${data!['capturedimage']}'),
                                    ),
                                  ),
                                ),*/

                                ///qr end
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),

                            ///gem code
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
                                      '${_formatDateAndTime(data?['date & time'])}',
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

                            ///gem code
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
                                      'IP when signed up :',
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
                                      '${data?['initip']}',
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
                                      'IP when attempted :',
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
                                      '${data?['ip']}',
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
                            Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 60,
                              width: double.infinity,
                              color: AppColors.backgroundcolor,
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Spacer(),
                                  Text(
                                    '${data?['location']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                        height: 2,
                                        color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.content_copy,
                                        color: Colors.white),
                                    onPressed: () async {},
                                  ),
                                ],
                              ),
                            ),
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
