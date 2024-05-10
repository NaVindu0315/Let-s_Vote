import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_new_Election_settings.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../../Colors/colors.dart';
import '../../management/mng_election_select_page.dart';

class election_setup_3 extends StatefulWidget {
  const election_setup_3({Key? key}) : super(key: key);

  @override
  State<election_setup_3> createState() => _election_setup_3State();
}

class _election_setup_3State extends State<election_setup_3> {
  ///variables end
  ///variables to set
  String name1candi = "";
  String name2candi = "";
  String name3candi = "";
  String name4candi = "";
  String name5candi = "";
  String nameelection = "";

  ///variables to set end
  ///
  ///controllers
  TextEditingController name1controller = TextEditingController();
  TextEditingController name2controller = TextEditingController();
  TextEditingController name3controller = TextEditingController();
  TextEditingController name4controller = TextEditingController();
  TextEditingController name5controller = TextEditingController();
  TextEditingController electioncontroller = TextEditingController();

  ///controllers end
  ///database referenneces
  late DatabaseReference _candidate1nameref;
  late DatabaseReference _candidate2nameref;
  late DatabaseReference _candidate3nameref;
  late DatabaseReference _candidate4nameref;
  late DatabaseReference _candidate5nameref;
  late DatabaseReference _electionnameref;
  late DatabaseReference _uidreference;

  late DatabaseReference _iselectionreference;
  late DatabaseReference _issavedreference;
  late DatabaseReference _isresultsreference;

  ///references end
  ///

  @override
  void initState() {
    super.initState();

    ///initialzing
    _electionnameref = FirebaseDatabase.instance.reference().child('el_name');
    _candidate1nameref = FirebaseDatabase.instance.reference().child('candi_1');
    _candidate2nameref = FirebaseDatabase.instance.reference().child('candi_2');
    _candidate3nameref = FirebaseDatabase.instance.reference().child('candi_3');
    _candidate4nameref = FirebaseDatabase.instance.reference().child('candi_4');
    _candidate5nameref = FirebaseDatabase.instance.reference().child('candi_5');
    _uidreference = FirebaseDatabase.instance.reference().child('uuids');

    _iselectionreference =
        FirebaseDatabase.instance.reference().child('election');
    _issavedreference = FirebaseDatabase.instance.reference().child('issaved');
    _isresultsreference =
        FirebaseDatabase.instance.reference().child('results');

    /// initialzing end
  }

  ///functions
  ///
  Future<void> setissavedto0() async {
    await _issavedreference.set(0);
  }

  Future<void> enablevotingbuttons() async {
    await _uidreference.remove();
  }

  Future<void> enableelectiondisbaleresults() async {
    await _iselectionreference.set(1);
    await _isresultsreference.set(0);
  }

  ///mail send
  String username = 'letsvotelv2024@gmail.com';
  String password = 'edpxfzzripyqjqms';

  final smtpServer = gmail('letsvotelv2024@gmail.com', 'edpxfzzripyqjqms');

  Future<void> SendMailtoAll(
      String elname, String cn1, String cn2, String cn3) async {
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
          'Candidates :  $cn1 , $cn2 , $cn3   \n'
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
  ///save rtdb data
  Future<void> createnewelectioon(String ename, String c1, String c2, String c3,
      String c4, String c5) async {
    await _electionnameref.set(ename);
    await _candidate1nameref.set(c1);
    await _candidate2nameref.set(c2);
    await _candidate3nameref.set(c3);
    await _candidate4nameref.set(c4);
    await _candidate5nameref.set(c5);
  }

  ///functions end

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundcolor,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Mng_new_Election_settings()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            '3 Person Election ',
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
                          nameelection = value;
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

              ///1 candidate
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
                        controller: name1controller,
                        onChanged: (value) {
                          //email = value;
                          name1candi = value;
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

              /// 2candidate
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
                        controller: name2controller,
                        onChanged: (value) {
                          //email = value;
                          name2candi = value;
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

              /// 3 candidate
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
                        controller: name3controller,
                        onChanged: (value) {
                          //email = value;
                          name3candi = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_add_alt_1_sharp,
                          ),
                          labelText: 'Candidate 3',
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
                      onPressed: () {
                        /*print(nameelection);
                        print(name1candi);
                        print(name2candi);
                        print(name3candi);
                        print(name4candi);
                        print(name5candi);*/

                        SendMailtoAll(
                          nameelection,
                          name1candi,
                          name2candi,
                          name3candi,
                        );
                        createnewelectioon(nameelection, name1candi, name2candi,
                            name3candi, "-", "-");

                        enableelectiondisbaleresults();
                        electioncontroller.clear();
                        name1controller.clear();
                        name2controller.clear();
                        name3controller.clear();
                        name4controller.clear();
                        name5controller.clear();

                        enablevotingbuttons();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Mng_new_Election_settings()),
                        );
                      },
                      child: Text(
                        'Create  Election',
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
