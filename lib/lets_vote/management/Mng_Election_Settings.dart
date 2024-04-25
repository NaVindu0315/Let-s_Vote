import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';

import '../../Colors/colors.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mng_Election_Settings extends StatefulWidget {
  const Mng_Election_Settings({Key? key}) : super(key: key);

  @override
  State<Mng_Election_Settings> createState() => _Mng_Election_SettingsState();
}

class _Mng_Election_SettingsState extends State<Mng_Election_Settings> {
  ///mail send
  String username = 'letsvotelv2024@gmail.com';
  String password = 'edpxfzzripyqjqms';

  final smtpServer = gmail('letsvotelv2024@gmail.com', 'edpxfzzripyqjqms');

  Future<void> MailSend(String title, String msg) async {
    final message = Message()
      ..from = Address(username)
      ..recipients.add('electionofficerletsvote@gmail.com')
      ..subject = title
      ..text = msg;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
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
  late String candidate1;
  late String candidate2;
  late String electionname;

  ///realtime data
  ///
  String candidatename1 = "Candidate1";
  String candidatename2 = "candidate2";
  String election = "election name";

  ///relatime data end

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
            'Election Settings',
            style: TextStyle(fontSize: 30.0, color: AppColors.buttoncolor),
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
                          electionname = value;
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
                      onPressed: () {
                        candidate1controller.clear();
                        candidate2controller.clear();
                        electioncontroller.clear();
                      },
                      child: Text(
                        'Create New Election',
                        style: TextStyle(
                            fontSize: 20.0, color: AppColors.backgroundcolor),
                      )),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 30.0,
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
                              color: AppColors.buttoncolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '             $election ',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backgroundcolor),
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
                              color: AppColors.buttoncolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename1 ',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backgroundcolor),
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
                              color: AppColors.buttoncolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   3',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            color: AppColors.buttontextcolor,
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
                              color: AppColors.buttoncolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename2 ',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.backgroundcolor),
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
                              color: AppColors.buttoncolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   3',
                                        style: TextStyle(
                                            fontSize: 28.0,
                                            color: AppColors.buttontextcolor,
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
                      onPressed: () {},
                      child: Text(
                        'Save & Clear Election Data',
                        style: TextStyle(
                            fontSize: 20.0, color: AppColors.backgroundcolor),
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
