import 'package:flutter/material.dart';

import '../../Colors/colors.dart';
import 'emp_dashboard.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Emp_Complaints extends StatefulWidget {
  const Emp_Complaints({Key? key}) : super(key: key);

  @override
  State<Emp_Complaints> createState() => _Emp_ComplaintsState();
}

class _Emp_ComplaintsState extends State<Emp_Complaints> {
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
                MaterialPageRoute(builder: (context) => Emp_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Report Your Issues',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
      ),
    );
  }
}
