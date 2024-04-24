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
  TextEditingController msgcontrller = TextEditingController();
  String titlee = "";
  String msgg = "";

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
                  'Voting Enabled',
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
            )
          ],
        ),
      ),
    );
  }
}
