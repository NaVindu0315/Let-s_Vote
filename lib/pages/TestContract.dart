import 'package:flutter/material.dart';

import '../Colors/colors.dart';
import 'Voting_home.dart';

class TestContract extends StatefulWidget {
  const TestContract({Key? key}) : super(key: key);

  @override
  State<TestContract> createState() => _TestContractState();
}

class _TestContractState extends State<TestContract> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 32.0,
              ),
              /*    Container(
                            height: 100, // Set the desired height
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(
                                  50), // Set the desired color
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 20.0,
                                ),
                                Expanded(
                                  child: Text(
                                    '${data!['username']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 170.0,
                                ),
                                Expanded(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    minRadius: 70.5,
                                    child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage:
                                            //AssetImage('images/g.png'),
                                            NetworkImage('${data!['url']}')),
                                  ),
                                ),
                              ],
                            ),
                          ),*/

              ///column
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70.0,
                  ),
                  // Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => voting_home()),
                            );
                          },
                          child: Text(
                            'Voting Home',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            //  callnameFunction("getname");
                          },
                          child: Text(
                            'Get Name',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            //  agefunction("getname");
                            //    callagefunction("getname");
                          },
                          child: Text(
                            'Get Name ',
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(
                        width: 10.0,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            //  agefunction("getdob");

                            //  callagefunction("getdob");
                          },
                          child: Text(
                            'Get  Birthday',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {},
                          child: Text(
                            'Next Page',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            //    loadJsonFromFirebase();
                          },
                          child: Text(
                            'Json Test',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  //   Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
