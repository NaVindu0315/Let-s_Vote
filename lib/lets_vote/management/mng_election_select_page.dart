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
  int el_num = 0;

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
                height: 150.0,
              ),
              Row(
                children: [
                  Spacer(),
                  Text(
                    '$el_num',
                    style: TextStyle(fontSize: 40.0, color: Colors.white),
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
