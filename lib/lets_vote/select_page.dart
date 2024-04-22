import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Colors/colors.dart';
import '../pages/Attempts/List_Succesful_attempts.dart';
import '../pages/Attempts/List_failed.dart';
import '../pages/Attempts/List_other_errors.dart';
import '../pages/Attempts/employee_list.dart';
import '../pages/Voting_home.dart';
import '../pages/welcome screen.dart';

class Selection_page extends StatefulWidget {
  const Selection_page({Key? key}) : super(key: key);

  @override
  State<Selection_page> createState() => _Selection_pageState();
}

class _Selection_pageState extends State<Selection_page> {
  void fuck() {}

  /*Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Management OTP'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter Management OTP'),
              onChanged: (value) {
                inpotp = int.parse(value);
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (inpotp == ootp) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoard()),
                      );
                    } else {
                      print("hukapn poonnaya");

                      fuck();
                    }
                  },
                  child: Text('Submit'))
            ],
          ));*/
  Future<void> openDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Management OTP'),
              content: TextField(
                decoration: InputDecoration(hintText: 'Enter Management OTP'),
                onChanged: (value) {
                  inpotp = int.parse(value);
                },
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (inpotp == ootp) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DashBoard()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sending wrong OTP')),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'))
              ],
            ));
  }

  int inpotp = 0000;
  int ootp = 0;

  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child('ootp');

    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          ootp = snapshot.value as int;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,

          title: Center(
            child: Text(
              'Please Select To Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              // Background image container
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/bg_image.jpg'), // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 180.0,
                    ),

                    ///main
                    Column(
                      //first row
                      children: [
                        ///Row for the text field

                        ///row end
                        Row(
                          children: [
                            //second box
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                /*    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => employee_list()),
                                );*/
                                openDialog();
                                print(ootp);
                              },
                              child: Container(
                                  height: 180.0,
                                  child: Card(
                                    color: AppColors.backgroundcolor,
                                    child: Image.asset('assets/m.png'),
                                  ),
                                  margin: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    //color: Color(0xFF101E33),
                                    color: AppColors.backgroundcolor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                            )),
                          ],
                        ),

                        SizedBox(
                          height: 100.0,
                        ),

                        ///second row
                        Row(
                          children: [
                            //first box
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => employee_list()),
                                );
                              },
                              child: Container(
                                  height: 180.0,
                                  child: Card(
                                    color: AppColors.backgroundcolor,
                                    child: Image.asset('assets/e.png'),
                                  ),
                                  margin: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                    //color: Color(0xFF101E33),
                                    color: AppColors.backgroundcolor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
