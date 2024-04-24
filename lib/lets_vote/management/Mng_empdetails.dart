import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Colors/colors.dart';
import 'package:intl/intl.dart';

late User loggedinuser;
late String client;

class Mng_detailed_employee extends StatefulWidget {
  final String selectedusser;

  Mng_detailed_employee({required this.selectedusser});

  @override
  _Mng_detailed_employeeState createState() => _Mng_detailed_employeeState();
}

class _Mng_detailed_employeeState extends State<Mng_detailed_employee> {
  GlobalKey globalKey = new GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String selectedattempt;

  @override
  void initState() {
    super.initState();
    selectedattempt = widget.selectedusser;
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
          .collection('users')
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
                    'Employee Details',
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
                                            NetworkImage('${data!['url']}'))),
                                /*  Spacer(),
                                CircleAvatar(
                                    backgroundColor: Colors.red,
                                    minRadius: 73,
                                    child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage:
                                            //AssetImage('images/g.png'),
                                            NetworkImage(
                                                '${data!['capturedimage']}'))),*/
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
                                      'username :',
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
                                      '${data?['username']}',
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
                                      'Address :',
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
                                      '${data?['address']}',
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
                                      'Date of Birth :',
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
                                      '${data?['dob']}',
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
                                      'Mobile :',
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
                                      '${data?['mobile']}',
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
                                      'Initial IP  :',
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

                            ///gem code end
                            ///gem name
                            ///gem name

                            ///gem name end
                            ///gem name end
                            ///gem variety

                            ///total cost end
                            /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF43468E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 12.0),
                                    textStyle: TextStyle(
                                        fontSize: 20.0, color: Color(0xFF43468E)),
                                  ),
                                  child: Text('Back'),
                                ),
                                SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    /*
                                    FirebaseFirestore.instance
                                        .collection(client)
                                        .doc(selectedattempt)
                                        .delete();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => gemlist()),
                                    );*/
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF43468E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 12.0),
                                    textStyle: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                  ),
                                  child: Text('sold'),
                                ),
                              ],
                            ),*/
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
