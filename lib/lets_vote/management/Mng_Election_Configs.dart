import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';

import '../../Colors/colors.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mng_Election_configs extends StatefulWidget {
  const Mng_Election_configs({Key? key}) : super(key: key);

  @override
  State<Mng_Election_configs> createState() => _Mng_Election_configsState();
}

class _Mng_Election_configsState extends State<Mng_Election_configs> {
  double lvl = 0.0;
  int iselection = 0;
  int isresults = 0;

  double setlvl = 0.0;

  TextEditingController lvlcontroller = TextEditingController();

  late DatabaseReference _elctionreference;
  late DatabaseReference _resultreference;
  late DatabaseReference _levlreferece;

  Future<void> levelset(double lvl) async {
    await _levlreferece.set(lvl);
  }

  Future<void> disableelection() async {
    await _elctionreference.set(0);
  }

  Future<void> enableelection() async {
    await _elctionreference.set(1);
  }

  Future<void> enableresults() async {
    await _resultreference.set(1);
  }

  Future<void> disableresults() async {
    await _resultreference.set(0);
  }

  @override
  void initState() {
    super.initState();

    _levlreferece = FirebaseDatabase.instance.reference().child('level');
    _elctionreference = FirebaseDatabase.instance.reference().child('election');
    _resultreference = FirebaseDatabase.instance.reference().child('results');

    _elctionreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          iselection = snapshot.value as int;
        });
      }
    });

    _resultreference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          isresults = snapshot.value as int;
        });
      }
    });

    _levlreferece.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          lvl = snapshot.value as double;
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
                MaterialPageRoute(builder: (context) => Mng_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Election Configs',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  'Change Configs',
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
                Spacer(),
                Text(
                  'Current Similarity Level - $lvl',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                SizedBox(
                  height: 70,
                  width: 300, // Set the width of the SizedBox to 300 pixels
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: lvlcontroller,
                      onChanged: (value) {
                        //email = value;
                        setlvl = value as double;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.summarize_outlined,
                        ),
                        labelText: 'New Similarity level',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Set',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  'Voting Enabled  $iselection',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Enable',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Disable',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  'Results Enabled  $isresults',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Enable',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.buttoncolor,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Disable',
                      style: TextStyle(
                          fontSize: 30.0, color: AppColors.backgroundcolor),
                    )),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
