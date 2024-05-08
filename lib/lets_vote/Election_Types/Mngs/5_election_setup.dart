import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../Colors/colors.dart';
import '../../management/mng_election_select_page.dart';

class election_setup_5 extends StatefulWidget {
  const election_setup_5({Key? key}) : super(key: key);

  @override
  State<election_setup_5> createState() => _election_setup_5State();
}

class _election_setup_5State extends State<election_setup_5> {
  ///declaring variables to fetch from rtdb
  String candidatename1 = "-";
  String candidatename2 = "-";
  String candidatename3 = "-";
  String candidatename4 = "-";
  String candidatename5 = "-";

  String electionname = "";

  int cn1votes = 0;
  int cn2votes = 0;
  int cn3votes = 0;
  int cn4votes = 0;
  int cn5votes = 0;

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

    /// initialzing end
    /// assigning values
    /// 1 candidate
    _candidate1nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename1 = snapshot.value.toString();
        });
      }
    });

    ///2nd candidate
    _candidate2nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename2 = snapshot.value.toString();
        });
      }
    });

    ///3rd candidate
    _candidate3nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename3 = snapshot.value.toString();
        });
      }
    });

    ///4th candidate
    _candidate4nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename4 = snapshot.value.toString();
        });
      }
    });

    ///5th candidate
    _candidate5nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename5 = snapshot.value.toString();
        });
      }
    });

    ///election name
    _electionnameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          electionname = snapshot.value.toString();
        });
      }
    });

    /// assgining values end
  }

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
                    builder: (context) => mng_election_type_select()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            '5 Person Election ',
            style: TextStyle(fontSize: 26.0, color: AppColors.buttoncolor),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(),
              SizedBox(
                height: 500.0,
              ),

              ///election name
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '             $electionname ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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

              ///firstcandidate
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename1 ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   6',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppColors.buttoncolor,
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

              ///second candidate
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename2 ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   5',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppColors.buttoncolor,
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

              ///3rd candidate
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename3 ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   5',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppColors.buttoncolor,
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

              ///
              /// 4th candidate
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename4 ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   5',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppColors.buttoncolor,
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

              ///
              /// 5th candidate
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '  $candidatename5 ',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttoncolor),
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
                            height: 40.0,
                            child: Card(
                              color: AppColors.backgroundcolor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '   5',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppColors.buttoncolor,
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
            ],
          ),
        ),
      ),
    );
  }
}
