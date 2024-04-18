import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:lets_vote/test_voting/test_functions.dart';
import 'package:path/path.dart';

import 'package:web3dart/web3dart.dart';
import '../Colors/colors.dart';
import 'test_constants.dart';
import 'package:quickalert/quickalert.dart';

import 'package:flutter_charts/flutter_charts.dart';

import 'package:flutter_graph/flutter_graph.dart';

class Test_vote_Results extends StatefulWidget {
  const Test_vote_Results({Key? key}) : super(key: key);

  @override
  State<Test_vote_Results> createState() => _Test_vote_ResultsState();
}

class _Test_vote_ResultsState extends State<Test_vote_Results> {
  Client? httpClient;
  Web3Client? ethClient;
  String candidate_1 = "-";
  String candidate_2 = "-";

  late DatabaseReference _candidate_1;
  late DatabaseReference _candidate_2;

  double votesCandidate1 = 0;
  double votesCandidate2 = 0;

  int cn1 = 0;
  int cn2 = 0;
  late Future<List> _cndi2future;

  late Future<List> _cndi1future;
  int _displayText2 = 0; // Variable to store the value obtained from the future
  int _displayText1 = 0;
  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);

    _candidate_1 = FirebaseDatabase.instance.reference().child('candi_1');
    _candidate_2 = FirebaseDatabase.instance.reference().child('candi_2');

    _candidate_1.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidate_1 = snapshot.value.toString();
        });
      }
    });

    _candidate_2.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidate_2 = snapshot.value.toString();
        });
      }
    });

    _cndi2future =
        getvotes_2(ethClient!); // Assuming getvotes_2 returns a Future<List>

    _cndi1future = getvotes_1(ethClient!);

    _cndi2future.then((value) {
      setState(() {
        _displayText2 = int.parse(value[0].toString());
        // Update the display text when future completes
        votesCandidate2 = _displayText2.toDouble();
      });
    });

    _cndi1future.then((value) {
      setState(() {
        _displayText1 = int.parse(value[0].toString());
        // Update the display text when future completes
        votesCandidate1 = _displayText1.toDouble();
      });
    });

    super.initState();
  }

  double cnn1 = 0;
  int cnn2 = 0;

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
            'Test Vote Results',
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
                      FutureBuilder<List>(
                          future: getvotes_1(ethClient!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Text(
                              snapshot.data![0].toString(),
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getvotes_2(ethClient!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Text(
                              snapshot.data![0].toString(),
                              style: TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                    ],
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
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        '$candidate_1 & $votesCandidate1',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        '$candidate_2 & $votesCandidate2',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),

              ///candidate display row end

              Spacer(),

              ///row for the buttons
              Row(
                children: [
                  Spacer(),
                  BarChartWidget(
                    bars: [votesCandidate1, votesCandidate2],
                    labels: [
                      '$candidate_1',
                      '$candidate_2',
                    ],
                    barColor: Colors.blueAccent,
                    axisLineColor: Colors.red,
                    barGap: 4.0,
                    size: Size(300, 400),
                  ),
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
