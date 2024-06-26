import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/management/Mng_Election_Settings.dart';

import '../../Colors/colors.dart';
import '../Election_Types/Mngs/2_election_setup.dart';
import '../Election_Types/Mngs/3_election_setup.dart';
import '../Election_Types/Mngs/4_election_setup.dart';
import '../Election_Types/Mngs/5_election_setup.dart';

class mng_election_type_select extends StatefulWidget {
  const mng_election_type_select({Key? key}) : super(key: key);

  @override
  State<mng_election_type_select> createState() =>
      _mng_election_type_selectState();
}

class _mng_election_type_selectState extends State<mng_election_type_select> {
  int el_type = 0;
  int el_num = 0;

  late DatabaseReference _electiontype;

  Future<void> setelectiontype(int num) async {
    await _electiontype.set(num);
  }

  @override
  void initState() {
    super.initState();

    _electiontype = FirebaseDatabase.instance.reference().child('electiontype');

    _electiontype.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          el_type = snapshot.value as int;
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
                  SizedBox(
                    height: 250.0,
                  ),
                  Spacer(),
                  /*    Text(
                    'paka',
                    style: TextStyle(color: Colors.white),
                  ),*/
                  PopupMenuButton<int>(
                    color: Colors.white,
                    // This will change the background color of the popup menu
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            10.0), // This will round the edges of the container
                      ),
                      child: const Text("choose Election type",
                          style: TextStyle(color: Colors.black, fontSize: 30)),
                    ),
                    onSelected: (value) {
                      print(value);
                      el_num = value;
                      print(el_num);
                      setelectiontype(el_num);
                    },
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          child: Text("2 person election",
                              style: TextStyle(
                                  color: Colors
                                      .black)), // This will change the text color of the item
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text("3 person election",
                              style: TextStyle(
                                  color: Colors
                                      .black)), // This will change the text color of the item
                          value: 3,
                        ),
                        PopupMenuItem(
                          child: Text("4 person election",
                              style: TextStyle(
                                  color: Colors
                                      .black)), // This will change the text color of the item
                          value: 4,
                        ),
                        PopupMenuItem(
                          child: Text("5 person election",
                              style: TextStyle(
                                  color: Colors
                                      .black)), // This will change the text color of the item
                          value: 5,
                        ),
                      ];
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    '$el_type',
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 150.0,
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        ///2 person
                        if (el_type == 2) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => election_setup_2()),
                          );
                        }

                        ///3 person
                        else if (el_type == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => election_setup_3()),
                          );
                        }

                        ///4 person
                        else if (el_type == 4) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => election_setup_4()),
                          );
                        }

                        ///5 person
                        else if (el_type == 5) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => election_setup_5()),
                          );
                        }
                      },
                      child: Text('Continue')),
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
