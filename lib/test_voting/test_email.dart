import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:lets_vote/pages/welcome%20screen.dart';

import '../Colors/colors.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Test_Email extends StatefulWidget {
  const Test_Email({Key? key}) : super(key: key);

  @override
  State<Test_Email> createState() => _Test_EmailState();
}

class _Test_EmailState extends State<Test_Email> {
  String username = 'nmails6969@gmail.com';
  String password = 'huujfezvmgbhmnmz';

  final smtpServer = gmail('nmails6969@gmail.com', 'huujfezvmgbhmnmz');

  TextEditingController rcvercontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController msgcontrller = TextEditingController();

  String reciverr = "";
  String titlee = "";
  String msgg = "";

  Future<void> SenDMail() async {
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add('navindulakshan99@gmail.com')
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.';

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

  Future<void> Autosend() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('useremails').get();
    List<String> emailList = [];
    for (var doc in querySnapshot.docs) {
      emailList.add(doc['umail']);
    }
    final message = Message()
      ..from = Address(username)
      ..subject = 'Your subject here'
      ..text = 'Your message here';
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

  Future<void> MailSend(String recver, String title, String msg) async {
    final message = Message()
      ..from = Address(username)
      ..recipients.add(recver)
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashBoard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Test Email',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Spacer(),

              ///vote count display row
              Row(
                children: [
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            SenDMail();
                          },
                          child: Text('Mail'))
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [],
                  ),
                  Spacer(),
                ],
              ),

              /// vote count display row end
              SizedBox(
                height: 10.0,
              ),

              ///row to display name of the candidates
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
                        controller: rcvercontroller,
                        onChanged: (value) {
                          //email = value;
                          reciverr = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.receipt,
                          ),
                          labelText: 'Reciver',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //title
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
                        controller: titlecontroller,
                        onChanged: (value) {
                          //email = value;
                          titlee = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.title,
                          ),
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //msg
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
                        controller: msgcontrller,
                        onChanged: (value) {
                          //email = value;
                          msgg = value;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.message,
                          ),
                          labelText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ///candidate display row end

              Spacer(),

              ///row for the buttons
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        MailSend(reciverr, titlee, msgg);
                        rcvercontroller.clear();
                        titlecontroller.clear();
                        msgcontrller.clear();
                      },
                      child: Text('Send')),
                  Spacer(),
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        Autosend();
                        //MailSend(reciverr, titlee, msgg);
                        rcvercontroller.clear();
                        titlecontroller.clear();
                        msgcontrller.clear();
                      },
                      child: Text('Auto Send')),
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
