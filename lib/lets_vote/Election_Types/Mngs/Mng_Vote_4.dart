import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:lets_vote/lets_vote/employees/emp_dashboard.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:lets_vote/test_voting/test_functions.dart';

import 'package:web3dart/web3dart.dart';
import '../../../Colors/colors.dart';
import '../../../test_voting/test_constants.dart';

import 'package:quickalert/quickalert.dart';

late User loggedinuser;
late String client;

class Mng_Vote_4 extends StatefulWidget {
  const Mng_Vote_4({Key? key}) : super(key: key);

  @override
  State<Mng_Vote_4> createState() => _Mng_Vote_4State();
}

class _Mng_Vote_4State extends State<Mng_Vote_4> {
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
  String electionname = "";

  String candidatename1 = "-";
  String candidatename2 = "-";
  String candidatename3 = "-";
  String candidatename4 = "-";
  String candidatename5 = "-";

  late DatabaseReference _candidate1nameref;
  late DatabaseReference _candidate2nameref;
  late DatabaseReference _candidate3nameref;
  late DatabaseReference _candidate4nameref;
  late DatabaseReference _candidate5nameref;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alermsg();
    });
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();

    getcurrentuser();

    uidref = FirebaseDatabase.instance.reference().child('uuids/$uuiid/stat');
    removeref = FirebaseDatabase.instance.reference().child('uuids');

    _candidate1reference =
        FirebaseDatabase.instance.reference().child('candi_1');
    _candidate2reference =
        FirebaseDatabase.instance.reference().child('candi_2');
    _electionnamereference =
        FirebaseDatabase.instance.reference().child('el_name');

    _candidate1reference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          cn1name = snapshot.value.toString();
        });
      }
    });

    _candidate2reference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          cn2name = snapshot.value.toString();
        });
      }
    });

    _electionnamereference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          electionname = snapshot.value.toString();
        });
      }
    });

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

    _candidate1nameref = FirebaseDatabase.instance.reference().child('candi_1');
    _candidate2nameref = FirebaseDatabase.instance.reference().child('candi_2');
    _candidate3nameref = FirebaseDatabase.instance.reference().child('candi_3');
    _candidate4nameref = FirebaseDatabase.instance.reference().child('candi_4');
    _candidate5nameref = FirebaseDatabase.instance.reference().child('candi_5');

    _candidate1nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename1 = snapshot.value.toString();
        });
      }
    });

    ///2nd candidate
    _candidate2nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename2 = snapshot.value.toString();
        });
      }
    });

    ///3rd candidate
    _candidate3nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename3 = snapshot.value.toString();
        });
      }
    });

    ///4th candidate
    _candidate4nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename4 = snapshot.value.toString();
        });
      }
    });

    ///5th candidate
    _candidate5nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename5 = snapshot.value.toString();
        });
      }
    });
  }

  void alermsg() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: 'Please Vote Carefully and wisely . You can only vote once',
      autoCloseDuration: const Duration(seconds: 4),
      showConfirmBtn: false,
    );
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
                MaterialPageRoute(builder: (context) => Mng_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            '4 Manager Voting',
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
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
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
                    '$electionname',
                    style:
                        TextStyle(color: AppColors.buttoncolor, fontSize: 30.0),
                  ),
                  Spacer(),
                ],
              ),

              /// vote count display row end
              SizedBox(
                height: 20.0,
              ),

              ///row to display name of the candidates

              ///candidate display row end
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 45.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ' $candidatename1 ',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),

                  ///blocckchian values here
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttoncolor,
                        ),
                        onPressed: uidf == 1
                            ? () {
                                vote_1(context, ethClient!);
                                deactivatebutton();
                              }
                            : null,
                        child: Text(
                          'Vote',
                          style: TextStyle(
                              fontSize: 15.0, color: AppColors.backgroundcolor),
                        ),
                      )),

                  ///blockchain values end
                ],
              ),

              ///second
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 45.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ' $candidatename2 ',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),

                  ///blocckchian values here
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttoncolor,
                        ),
                        onPressed: uidf == 1
                            ? () {
                                vote_2(context, ethClient!);
                                deactivatebutton();
                              }
                            : null,
                        child: Text(
                          'Vote',
                          style: TextStyle(
                              fontSize: 15.0, color: AppColors.backgroundcolor),
                        ),
                      )),

                  ///blockchain values end
                ],
              ),

              ///third
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 45.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ' $candidatename3 ',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),

                  ///blocckchian values here
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttoncolor,
                        ),
                        onPressed: uidf == 1
                            ? () {
                                vote_3(context, ethClient!);
                                deactivatebutton();
                              }
                            : null,
                        child: Text(
                          'Vote',
                          style: TextStyle(
                              fontSize: 15.0, color: AppColors.backgroundcolor),
                        ),
                      )),

                  ///blockchain values end
                ],
              ),

              ///4th
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 45.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ' $candidatename4 ',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),

                  ///blocckchian values here
                  Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.buttoncolor,
                        ),
                        onPressed: uidf == 1
                            ? () {
                                vote_4(context, ethClient!);
                                deactivatebutton();
                              }
                            : null,
                        child: Text(
                          'Vote',
                          style: TextStyle(
                              fontSize: 15.0, color: AppColors.backgroundcolor),
                        ),
                      )),

                  ///blockchain values end
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Text(
                    uidf == 0 ? 'You have already voted' : '',
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                  ),
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
