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
  String username = 'letsvotelv2024@gmail.com';
  String password = 'edpxfzzripyqjqms';

  final smtpServer = gmail('letsvotelv2024@gmail.com', 'edpxfzzripyqjqms');
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController msgcontrller = TextEditingController();
  String titlee = "";
  String msgg = "";

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
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  'Election Settings',
                  style:
                      TextStyle(fontSize: 30.0, color: AppColors.buttoncolor),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 50.0,
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
            SizedBox(
              height: 50.0,
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
            SizedBox(
              height: 50.0,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {
                      MailSend(titlee, msgg);
                      titlecontroller.clear();

                      msgcontrller.clear();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
