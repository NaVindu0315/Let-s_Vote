import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_Election_Settings.dart';

import '../../Colors/colors.dart';

class mng_election_type_select extends StatefulWidget {
  const mng_election_type_select({Key? key}) : super(key: key);

  @override
  State<mng_election_type_select> createState() =>
      _mng_election_type_selectState();
}

class _mng_election_type_selectState extends State<mng_election_type_select> {
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
                MaterialPageRoute(
                    builder: (context) => Mng_Election_Settings()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Select Election Type ',
            style: TextStyle(fontSize: 26.0, color: AppColors.buttoncolor),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  Text(
                    'paka',
                    style: TextStyle(color: Colors.white),
                  ),
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
