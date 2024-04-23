import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:lets_vote/lets_vote/employees/emp_dashboard.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:lets_vote/test_voting/test_functions.dart';

import 'package:web3dart/web3dart.dart';
import '../../Colors/colors.dart';
import '../../test_voting/test_constants.dart';

import 'package:quickalert/quickalert.dart';

late User loggedinuser;
late String client;

class Emp_Vote_Page extends StatefulWidget {
  const Emp_Vote_Page({Key? key}) : super(key: key);

  @override
  State<Emp_Vote_Page> createState() => _Emp_Vote_PageState();
}

class _Emp_Vote_PageState extends State<Emp_Vote_Page> {
  Client? httpClient;
  Web3Client? ethClient;

  late DatabaseReference uidref;

  late DatabaseReference removeref;
  String uuiid = "";
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
        print(loggedinuser.uid);
        uuiid = loggedinuser.uid;
      }
    } catch (e) {
      print(e);
    }

    Future<String> uidreturn() async {
      try {
        // final user = await _auth.currentUser();
        ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          loggedinuser = user;
          client = loggedinuser.email!;

          ///i have to call the getdatafrm the function here and parse client as a parameter

          print(loggedinuser.email);
          print(loggedinuser.uid);
        }
      } catch (e) {
        print(e);
      }
      return loggedinuser.uid;
    }
  }

  Future<void> deactivatebutton() async {
    await uidref.set(0);
  }

  Future<void> activatebutton() async {
    await uidref.set(1);
  }

  String uiddisplay = "";
  int uidf = 99;

  late DatabaseReference _candidate1reference;
  late DatabaseReference _candidate2reference;
  late DatabaseReference _electionnamereference;

  String cn1name = "";
  String cn2name = "";

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();

    getcurrentuser();

    uidref = FirebaseDatabase.instance.reference().child('uuids/$uuiid/stat');
    removeref = FirebaseDatabase.instance.reference().child('uuids');

    uidref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          uiddisplay = snapshot.value.toString();
          uidf = int.parse(uiddisplay);
        });
      } else {
        setState(() {
          uiddisplay = '1';
          uidf = int.parse(uiddisplay);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundcolor,
      ),
      home: Scaffold(
        appBar: AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emp_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Employee Voting',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 60.0,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'Please Vote Carefully',
                    style:
                        TextStyle(color: AppColors.buttoncolor, fontSize: 30.0),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 60.0,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    'You only get only once Chance to vote',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  Spacer(),
                ],
              ),

              ///vote count display row
              /*  Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getvotes_1(ethClient!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text(
                              snapshot.data![0].toString(),
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getvotes_2(ethClient!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text(
                              snapshot.data![0].toString(),
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                    ],
                  ),
                  Spacer(),
                ],
              )*/

              /// vote count display row end
              SizedBox(
                height: 70.0,
              ),

              ///row to display name of the candidates
              Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Candidate 1',
                        style: TextStyle(
                            color: AppColors.buttoncolor, fontSize: 30.0),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Candidate 2',
                        style: TextStyle(
                            color: AppColors.buttoncolor, fontSize: 30.0),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),

              ///candidate display row end
              SizedBox(
                height: 30.0,
              ),

              ///row for the buttons
              Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          vote_1(context, ethClient!);
                        },
                        child: Text(
                          'Vote 1',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          vote_2(context, ethClient!);
                        },
                        child: Text(
                          'Vote 2',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                ],
              ),
              /*  SizedBox(
                height: 25.0,
              ),

              ///bbuttons row end
              ///row for clear button
              ///
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        clearall(context, ethClient!);
                      },
                      child: Text('Clear Vote Count')),
                  Spacer(),
                ],
              ),

              ///button row end
              SizedBox(
                height: 25.0,
              ),

              ///bbuttons row end
              ///row for clear button
              ///
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Refresh')),
                  Spacer(),
                ],
              ),*/
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
