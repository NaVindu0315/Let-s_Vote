import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graph/flutter_graph.dart';
import 'package:lets_vote/lets_vote/employees/emp_dashboard.dart';
import 'package:lets_vote/lets_vote/management/Mng_Dashboard.dart';
import 'package:lets_vote/lets_vote/management/Mng_Election_Settings.dart';
import 'package:lets_vote/lets_vote/management/mng_election_select_page.dart';
import 'package:path/path.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../Colors/colors.dart';

import 'package:web3dart/web3dart.dart';
import '../../test_voting/test_constants.dart';
import '../../test_voting/test_functions.dart';
import 'package:http/http.dart';

class Emp_new_Election_results extends StatefulWidget {
  const Emp_new_Election_results({Key? key}) : super(key: key);

  @override
  State<Emp_new_Election_results> createState() =>
      _Emp_new_Election_resultsState();
}

class _Emp_new_Election_resultsState extends State<Emp_new_Election_results> {
  ///declaring variables to fetch from rtdb
  String candidatename1 = "-";
  String candidatename2 = "-";
  String candidatename3 = "-";
  String candidatename4 = "-";
  String candidatename5 = "-";

  String electionname = "";
  int election = 0;
  int electiontype = 0;
  int issaved = 0;
  int results = 0;

  int cn1votes = 0;
  int cn2votes = 0;
  int cn3votes = 0;
  int cn4votes = 0;
  int cn5votes = 0;

  ///variables end

  ///database referenneces
  late DatabaseReference _candidate1nameref;
  late DatabaseReference _candidate2nameref;
  late DatabaseReference _candidate3nameref;
  late DatabaseReference _candidate4nameref;
  late DatabaseReference _candidate5nameref;
  late DatabaseReference _electionnameref;
  late DatabaseReference _electionavailableref;
  late DatabaseReference _issavedref;
  late DatabaseReference _isreusltsref;
  late DatabaseReference _electiontyperef;

  ///references end
  ///
  ///blockchain\
  Client? httpClient;
  Web3Client? ethClient;

  late Future<List> _cndi1future;
  late Future<List> _cndi2future;
  late Future<List> _cndi3future;
  late Future<List> _cndi4future;
  late Future<List> _cndi5future;

  double doublecn1 = 0.0;
  double doublecn2 = 0.0;
  double doublecn3 = 0.0;
  double doublecn4 = 0.0;
  double doublecn5 = 0.0;

  ///blockchaiin end
  @override
  void initState() {
    super.initState();

    ///initialzing
    _electionavailableref =
        FirebaseDatabase.instance.reference().child('election');
    _issavedref = FirebaseDatabase.instance.reference().child('issaved');
    _isreusltsref = FirebaseDatabase.instance.reference().child('results');
    _electiontyperef =
        FirebaseDatabase.instance.reference().child('electiontype');

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

    ///election avialable
    _electionavailableref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          election = snapshot.value as int;
        });
      }
    });

    ///issaved
    _issavedref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          issaved = snapshot.value as int;
        });
      }
    });

    ///isreuslkts
    _isreusltsref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          results = snapshot.value as int;
        });
      }
    });

    ///electiontype
    _electiontyperef.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          electiontype = snapshot.value as int;
        });
      }
    });

    /// assgining values end
    ///
    /// blockchain

    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);

    _cndi1future = getvotes_1(ethClient!);
    _cndi2future = getvotes_2(ethClient!);
    _cndi3future = getvotes_3(ethClient!);
    _cndi4future = getvotes_4(ethClient!);
    _cndi5future = getvotes_5(ethClient!);

    ///values assigning
    _cndi1future.then((value) {
      setState(() {
        cn1votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
        doublecn1 = cn1votes.toDouble();
      });
    });

    _cndi2future.then((value) {
      setState(() {
        cn2votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
        doublecn2 = cn2votes.toDouble();
      });
    });

    _cndi3future.then((value) {
      setState(() {
        cn3votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
        doublecn3 = cn3votes.toDouble();
      });
    });

    _cndi4future.then((value) {
      setState(() {
        cn4votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
        doublecn4 = cn4votes.toDouble();
      });
    });

    _cndi5future.then((value) {
      setState(() {
        cn5votes = int.parse(value[0].toString());
        // Update the display text when future completes
        //  votesCandidate1 = _displayText1.toDouble();
        doublecn5 = cn5votes.toDouble();
      });
    });

    /// blokchain end
  }

  Future<void> setissavedto0() async {
    await _issavedref.set(0);
  }

  Future<void> setissavedto1() async {
    await _issavedref.set(1);
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
                MaterialPageRoute(builder: (context) => Emp_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Election Results - Employee',
            style: TextStyle(fontSize: 26.0, color: AppColors.buttoncolor),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ///electionname textbox
              ///candidate 1 textbox
              ///candidate 2 textbox
              ///candidate 3 textbox
              ///candidate 4 textbox
              ///candidate 5 textbox

              ///election name
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 60.0,
                  ),
                  BarChartWidget(
                    bars: [
                      doublecn1,
                      doublecn2,
                      doublecn3,
                      doublecn4,
                      doublecn5
                    ],
                    labels: [
                      '$candidatename1',
                      '$candidatename2',
                      '$candidatename3',
                      '$candidatename4',
                      '$candidatename5',
                    ],
                    barColor: Colors.blueAccent,
                    axisLineColor: AppColors.buttoncolor,
                    barGap: 12.0,
                    size: Size(250, 350),
                  ),
                ],
              ),

              ///election available

              ///

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
                                        '  Name       :      $electionname ',
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
                                        '   $cn1votes',
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
                                        '   $cn2votes',
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
                                        '   $cn3votes',
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
                                        '   $cn4votes',
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
                                        '   $cn5votes',
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
