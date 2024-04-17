import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:lets_vote/test_voting/test_functions.dart';

import 'package:web3dart/web3dart.dart';
import '../Colors/colors.dart';
import 'test_constants.dart';
import 'package:quickalert/quickalert.dart';

class Vote_Home_2 extends StatefulWidget {
  const Vote_Home_2({Key? key}) : super(key: key);

  @override
  State<Vote_Home_2> createState() => _Vote_Home_2State();
}

class _Vote_Home_2State extends State<Vote_Home_2> {
  Client? httpClient;
  Web3Client? ethClient;

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

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
            'Test Voting Home',
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
                        'Candidate 1',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        'Candidate 2',
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
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          vote_1(context, ethClient!);
                        },
                        child: Text(
                          'Vote 1',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          vote_2(context, ethClient!);
                        },
                        child: Text(
                          'Vote 2',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),

              ///bbuttons row end
              ///row for clear button
              ///
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        clearall(context, ethClient!);
                      },
                      child: Text('Clear Vote Count')),
                  Spacer(),
                ],
              ),

              ///button row end
              SizedBox(
                height: 25.0,
              ),

              ///bbuttons row end
              ///row for clear button
              ///
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Refresh')),
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
