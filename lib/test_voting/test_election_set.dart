import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_vote/Colors/colors.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/Group_Chat.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/management_dashboard.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import 'package:lets_vote/test_voting/test_constants.dart';
import 'package:lets_vote/test_voting/test_functions.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:io';

import '../pages/Voting_home.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:http/http.dart' as http;

import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

import 'dart:async';

late User loggedinuser;
late String client;

class test_election_set extends StatefulWidget {
  const test_election_set({Key? key}) : super(key: key);

  @override
  State<test_election_set> createState() => _test_election_setState();
}

class _test_election_setState extends State<test_election_set> {
  Client? httpClient;
  Web3Client? ethClient;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController loggedinusercontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();

  ///for camera
  TextEditingController url1controller = TextEditingController();
  TextEditingController capturedimageurlcontroller = TextEditingController();
  late String url1img;
  String? videoPath;

  ///camera end
  ///
  ///firebase storage
  final storage = FirebaseStorage.instance;
  CameraController? controller;
  late String imagePath = "";
  late String uploadedimageurl = "";
  DateTime now = DateTime.now();

  late DatabaseReference _databaseReference;

  double level = 0.0;

  String candidate_1 = "-";
  String candidate_2 = "-";
  FirebaseDatabase database = FirebaseDatabase.instance;

  double setlvl = 70.6;

  TextEditingController lvlcontroller = TextEditingController();

  late DatabaseReference lvlsetref = FirebaseDatabase.instance.ref();

  Future<void> levelset(double lvl) async {
    await _databaseReference.set(lvl);
  }

  ///data fecthing and setting end
  ///
  late DatabaseReference _electionreference;

  late DatabaseReference _candidate_1;
  late DatabaseReference _candidate_2;
  int election = 5;

  Future<void> setelection1() async {
    await _electionreference.set(1);

    /* _electionreference.onDisconnect().set(8).then((_) {
      Future.delayed(Duration(hours: 2), () {
        database.goOffline();
      });
    });*/
  }

  Future<void> setauto0() async {
    await _electionreference.set(1);

    _electionreference.onDisconnect().set(0).then((_) {
      Future.delayed(Duration(hours: 1), () {
        database.goOffline();
      });
    });
  }

  Future<void> setschedule() async {
    // await _electionreference.set(1);

    _electionreference.onDisconnect().set(1).then((_) {
      Future.delayed(Duration(hours: 1), () {
        database.goOffline();
      });
    });

    _electionreference.onDisconnect().set(0).then((_) {
      Future.delayed(Duration(hours: 2), () {
        database.goOffline();
      });
    });
  }

  Future<void> setelection0() async {
    await _electionreference.set(0);
  }

  Future<void> setcandidates(String nm1, String nm2) async {
    await _candidate_1.set(nm1);
    await _candidate_2.set(nm2);
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);

    /// Initialize the FirebaseDatabase reference
    _databaseReference = FirebaseDatabase.instance.reference().child('level');
    _electionreference =
        FirebaseDatabase.instance.reference().child('election');
    _candidate_1 = FirebaseDatabase.instance.reference().child('candi_1');
    _candidate_2 = FirebaseDatabase.instance.reference().child('candi_2');

    //_initNetworkInfo();
    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          level = snapshot.value as double;
        });
      }
    });

    _electionreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          election = snapshot.value as int;
        });
      }
    });

    _candidate_1.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidate_1 = snapshot.value.toString();
        });
      }
    });

    _candidate_2.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidate_2 = snapshot.value.toString();
        });
      }
    });
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

  /// end

  ///function end

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(client)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return Scaffold(
                resizeToAvoidBottomInset: false,

                ///navigation bar eka iwrii
                ///drawer
                drawer: Drawer(
                  width: 300,
                  child: Container(
                    color: AppColors.backgroundcolor, //color of list tiles
                    // Add a ListView to ensures the user can scroll
                    child: ListView(
                      // Remove if there are any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color:
                                AppColors.buttoncolor, //color of drawer header
                          ),
                          accountName: Text(
                            '${data!['username']}',
                            style: TextStyle(
                              color: AppColors.backgroundcolor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          accountEmail: Text(
                            client,
                            style: TextStyle(
                                color: AppColors.backgroundcolor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('${data!['url']}'),
                          ),
                        ),

                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            title: const Text('Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );
                            },
                          );
                        }),

                        ///management dashboard
                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.manage_accounts,
                              color: Colors.white,
                            ),
                            title: const Text('Management dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Management_Dashboard()),
                              );
                            },
                          );
                        }),
                        //Cam page
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            title: const Text('Image Testing Page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myapp()),
                              );
                            },
                          );
                        }),
                        //Announcement
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.face,
                              color: Colors.white,
                            ),
                            title: const Text('Face Comparing Test',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Compare_page()),
                              );
                            },
                          );
                        }),

                        ///voting home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.how_to_vote,
                              color: Colors.white,
                            ),
                            title: const Text('Voting Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => voting_home()),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                ///drawwe end
                appBar: AppBar(
                  // preferredSize: Size.fromHeight(kToolbarHeight + 20),
                  backgroundColor: AppColors.backgroundcolor,

                  title: Text(
                    'test election Set $level ||  $election',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),

                  //centerTitle: true,
                ),
                body: Stack(children: [
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
                          height: 32.0,
                        ),
                        CircleAvatar(
                            backgroundColor: AppColors.backgroundcolor,
                            minRadius: 70.5,
                            child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    //AssetImage('images/g.png'),
                                    NetworkImage('${data!['url']}'))),

                        ///main
                        Column(
                          //first row
                          children: [
                            ///Row for the text field
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  '${data!['username']}',
                                  style: TextStyle(
                                      color: AppColors.backgroundcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                Spacer()
                              ],
                            ),

                            ///row for the designation
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  'CEO & HR Head',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                Spacer()
                              ],
                            ),

                            ///row for the designation end
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Current similarity level -  $level',
                                  style: TextStyle(
                                      color: AppColors.backgroundcolor,
                                      fontSize: 25.0),
                                ),
                                Spacer(),
                              ],
                            ),

                            ///row end
                            Row(
                              children: [
                                ///for the employee management
                                ///here
                                /* Expanded(
                                  child: Row(
                                    children: [],
                                  ),
                                    ),*/
                                SizedBox(
                                  height: 70,
                                  width:
                                      250, // Set the width of the SizedBox to 300 pixels
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller: lvlcontroller,
                                      onChanged: (value) {
                                        //email = value;
                                        setlvl = double.parse(value);
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.account_circle,
                                        ),
                                        labelText: 'Set new Value',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        lvlcontroller.clear();
                                        levelset(setlvl);
                                        print(setlvl);
                                      },
                                      child: Text('Set New Value')),
                                ),

                                ///end

                                ///for the camera preview
                              ],
                            ),

                            ///second row
                            Row(
                              children: [
                                ///to compare the face and navigate to the votig home
                                Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          height: 100.0,
                                          child: Card(
                                            color: AppColors.backgroundcolor,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '$candidate_1 ',
                                                      style: TextStyle(
                                                          fontSize: 30.0,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '$candidate_2',
                                                      style: TextStyle(
                                                          fontSize: 30.0,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          margin: EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            //color: Color(0xFF101E33),
                                            color: AppColors.backgroundcolor,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    )),

                                ///second
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                          height: 100.0,
                                          child: Card(
                                            color: AppColors.backgroundcolor,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    FutureBuilder<List>(
                                                        future: getvotes_1(
                                                            ethClient!),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          return Text(
                                                            snapshot.data![0]
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    FutureBuilder<List>(
                                                        future: getvotes_2(
                                                            ethClient!),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          }
                                                          return Text(
                                                            snapshot.data![0]
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          margin: EdgeInsets.all(15.0),
                                          decoration: BoxDecoration(
                                            //color: Color(0xFF101E33),
                                            color: AppColors.backgroundcolor,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          )),
                                    )),
                              ],
                            ),

                            Row(
                              children: [
                                Spacer(),
                                Text(
                                  'Election - ',
                                  style: TextStyle(
                                      color: AppColors.backgroundcolor,
                                      fontSize: 20.0),
                                ),
                                Text(
                                  election == 1
                                      ? 'Available Now'
                                      : 'Not Available Right Now',
                                  style: TextStyle(
                                      color: AppColors.backgroundcolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                Spacer(),
                              ],
                            ),
                            Row(
                              children: [
                                //first box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    setelection1();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 50.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Enable Voting',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),

                                //second box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    //onPressedStop();
                                    setelection0();
                                    HapticFeedback.mediumImpact();
                                  },
                                  child: Container(
                                      height: 50.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Disable Voting',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25.0),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                              ],
                            ),

                            ///third row
                            Row(
                              children: [
                                //first box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                      height: 90.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            '$level\n'
                                            '$election',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      )),
                                )),
                                //second box
                                Expanded(
                                    child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DashBoard()),
                                    );
                                  },
                                  child: Container(
                                      height: 90.0,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            'Default Home',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                      margin: EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        //color: Color(0xFF101E33),
                                        color: AppColors.backgroundcolor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
              );
            }
            return CircularProgressIndicator();
          }),
    ));
  }
}
