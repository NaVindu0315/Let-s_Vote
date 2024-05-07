import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:web3dart/web3dart.dart';

import '../../Colors/colors.dart';
import 'package:http/http.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../test_voting/test_constants.dart';
import '../../test_voting/test_functions.dart';

class Mng_Election_Settings extends StatefulWidget {
  const Mng_Election_Settings({Key? key}) : super(key: key);

  @override
  State<Mng_Election_Settings> createState() => _Mng_Election_SettingsState();
}

class _Mng_Election_SettingsState extends State<Mng_Election_Settings> {
  ///
  /// blockchcain
  Client? httpClient;
  Web3Client? ethClient;

  late Future<List> _cndi2future;

  late Future<List> _cndi1future;
  int cn2votes = 0; // Variable to store the value obtained from the future
  int cn1votes = 0;

  /// blcokchain end

  //firebase
  final _firestore = FirebaseFirestore.instance;
  DateTime now = DateTime.now();

  ///firebase end

  ///mail send
  String username = 'letsvotelv2024@gmail.com';
  String password = 'edpxfzzripyqjqms';

  final smtpServer = gmail('letsvotelv2024@gmail.com', 'edpxfzzripyqjqms');

  Future<void> SendMailtoAll(String elname, String cn1, String cn2) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('useremails').get();
    List<String> emailList = [];
    for (var doc in querySnapshot.docs) {
      emailList.add(doc['umail']);
    }
    final message = Message()
      ..from = Address(username)
      ..subject = 'New Election is Created'
      ..text = 'New election : $elname \n'
          'Candidates :  $cn1 , $cn2\n'
          'Please Vote wisely'
          'Thank You'
          'Election Officer';
    try {
      for (var email in emailList) {
        message.recipients.add(email);
        final sendReport = await send(message, smtpServer);
        print('Message sent to $email: ' + sendReport.toString());
      }
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  ///mail send end

  TextEditingController candidate1controller = TextEditingController();
  TextEditingController candidate2controller = TextEditingController();
  TextEditingController electioncontroller = TextEditingController();

  ///realtime data
  ///
  String candidatename1 = "Candidate1";
  String candidatename2 = "candidate2";
  String election = "election name";

  ///relatime data end
  ///variables for rtdb
  int iselection = 0;
  int issaved = 0;
  int isresults = 0;
  String candidate1 = "";
  String candidate2 = " ";
  String electionname = "";

  ///variables for rtdb end
  ///references
  late DatabaseReference _electionnamereference;
  late DatabaseReference _iselectionreference;
  late DatabaseReference _issavedreference;
  late DatabaseReference _isresultsreference;
  late DatabaseReference _candidate1reference;
  late DatabaseReference _cadndidate2reference;
  late DatabaseReference _uidreference;

  ///references end
  ///

  @override
  void initState() {
    super.initState();

    ///reference initilzing
    _electionnamereference =
        FirebaseDatabase.instance.reference().child('el_name');
    _iselectionreference =
        FirebaseDatabase.instance.reference().child('election');
    _issavedreference = FirebaseDatabase.instance.reference().child('issaved');
    _isresultsreference =
        FirebaseDatabase.instance.reference().child('results');
    _candidate1reference =
        FirebaseDatabase.instance.reference().child('candi_1');
    _cadndidate2reference =
        FirebaseDatabase.instance.reference().child('candi_2');
    _uidreference = FirebaseDatabase.instance.reference().child('uuids');

    ///reference end
    ///
    /// assigning values
    ///
    _iselectionreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          iselection = snapshot.value as int;
        });
      }
    });

    _isresultsreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          isresults = snapshot.value as int;
        });
      }
    });

    _issavedreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          issaved = snapshot.value as int;
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

    _candidate1reference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename1 = snapshot.value.toString();
        });
      }
    });

    _cadndidate2reference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename2 = snapshot.value.toString();
        });
      }
    });

    /// assigning values end
    ///
    /// blockchain values
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);

    _cndi2future =
        getvotes_2(ethClient!); // Assuming getvotes_2 returns a Future<List>

    _cndi1future = getvotes_1(ethClient!);

    _cndi2future.then((value) {
      setState(() {
        cn2votes = int.parse(value[0].toString());
        // Update the display text when future completes
        // votesCandidate2 = _displayText2.toDouble();
      });
    });

    _cndi1future.then((value) {
      setState(() {
        cn1votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
      });
    });

    /// blockchcian values assigning end
  }

  ///functons to set values to rtdb
  ///
  Future<void> setissavedto0() async {
    await _issavedreference.set(0);
  }

  Future<void> setissavedto1() async {
    await _issavedreference.set(1);
  }

  Future<void> enablevotingbuttons() async {
    await _uidreference.remove();
  }

  Future<void> enableelectiondisbaleresults() async {
    await _iselectionreference.set(1);
    await _isresultsreference.set(0);
  }

  Future<void> createnewelectioon(String ename, String c1, String c2) async {
    await _electionnamereference.set(ename);
    await _candidate1reference.set(c1);
    await _cadndidate2reference.set(c2);
  }

  Future<void> disablebothresultsandelections() async {
    await _iselectionreference.set(0);
    await _isresultsreference.set(0);
  }

  Future<void> resetnames() async {
    await _electionnamereference.set("-");
    await _candidate1reference.set("-");
    await _cadndidate2reference.set("-");
  }

  ///function for rtdb value end

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
            'Election Settings $iselection $isresults $issaved',
            style: TextStyle(fontSize: 26.0, color: AppColors.buttoncolor),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 400, // Set the width of the SizedBox to 300 pixels
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: electioncontroller,
                        onChanged: (value) {
                          //email = value;
                          election = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.how_to_vote,
                          ),
                          labelText: 'Election Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 400, // Set the width of the SizedBox to 300 pixels
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: candidate1controller,
                        onChanged: (value) {
                          //email = value;
                          candidate1 = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_add_alt_1_sharp,
                          ),
                          labelText: 'Candidate 1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 400, // Set the width of the SizedBox to 300 pixels
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: candidate2controller,
                        onChanged: (value) {
                          //email = value;
                          candidate2 = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_add_alt_1_sharp,
                          ),
                          labelText: 'Candidate 2',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.buttoncolor,
                      ),
                      onPressed: issaved == 1
                          ? () {
                              candidate1controller.clear();
                              candidate2controller.clear();
                              electioncontroller.clear();

                              setissavedto0();

                              ///mail to all users
                              //SendMailtoAll();
                              SendMailtoAll(election, candidate1, candidate2);

                              ///clear all uuids here
                              enablevotingbuttons();

                              ///results disbaled election enabled here
                              ///
                              ///
                              enableelectiondisbaleresults();

                              ///set realtime values here
                              createnewelectioon(
                                  election, candidate1, candidate2);
                            }
                          : () {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                title: 'Need To Save',
                                text:
                                    'Save and clear Previous Election Data before creating a new one',
                                backgroundColor: Colors.black,
                                titleColor: Colors.white,
                                textColor: Colors.white,
                              );
                            },
                      child: Text(
                        'Create New Election',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.backgroundcolor,
                            fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {}, child: Text('Election Selection Page')),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Text(
                    'Current Election Details',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),

              SizedBox(
                height: 20.0,
              ),

              ///To display results and names
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 53.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '             $electionname ',
                                        style: TextStyle(
                                            fontSize: 28.0,
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
                  ///blockchain values end
                ],
              ),

              ///second row
              ///
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 53.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename1 ',
                                        style: TextStyle(
                                            fontSize: 28.0,
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
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 53.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   $cn1votes',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            color: AppColors.buttoncolor,
                                            fontWeight: FontWeight.bold),
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

                  ///blockchain values end
                ],
              ),

              ///secodn row end
              ///

              ///third row
              ///
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 53.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename2 ',
                                        style: TextStyle(
                                            fontSize: 28.0,
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
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 53.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   $cn2votes',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            color: AppColors.buttoncolor,
                                            fontWeight: FontWeight.bold),
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

                  ///blockchain values end
                ],
              ),

              ///third row end
              SizedBox(
                height: 10.0,
              ),

              ///end displaynng
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.buttoncolor,
                      ),
                      onPressed: () {
                        ///add save data to firebase function here
                        String electionid = "$electionname$now";
                        final elc =
                            _firestore.collection("electionss").doc(electionid);
                        elc.set({
                          'electionname': "$electionname",
                          'candidate1': "$candidatename1",
                          'candidate2': "$candidatename2",
                          'cn1votes': cn1votes,
                          'cn2votes': cn2votes,
                          'electionid': electionid,
                          'date & time': now,
                        });
                        setissavedto1();

                        ///voting and reuslts disbale here
                        disablebothresultsandelections();

                        ///clear realtime data here
                        resetnames();

                        ///add blockchain clear all function here
                        ///
                        // voteclearblockchain(ethClient!);
                        clearall(context, ethClient!);

                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Election Saved',
                          text: 'Election Saved and Cleared',
                          backgroundColor: Colors.black,
                          titleColor: Colors.white,
                          textColor: Colors.white,
                        );
                      },
                      child: Text(
                        'Save & Clear Election Data',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: AppColors.backgroundcolor,
                            fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
