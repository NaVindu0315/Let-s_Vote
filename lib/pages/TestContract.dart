import 'package:flutter/material.dart';

import '../Colors/colors.dart';
import 'Voting_home.dart';

class TestContract extends StatefulWidget {
  const TestContract({Key? key}) : super(key: key);

  @override
  State<TestContract> createState() => _TestContractState();
}

class _TestContractState extends State<TestContract> {
  TextEditingController txtcontroller = new TextEditingController();
  String txt = "";
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
                            'Test Funcion',
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
                      SizedBox(
                        height: 70,
                        width:
                            350, // Set the width of the SizedBox to 300 pixels
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextFormField(
                            controller: txtcontroller,
                            onChanged: (value) {
                              txt = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.text_fields,
                              ),
                              labelText: 'Text',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.backgroundcolor)),
                          onPressed: () {
                            ///function to send text to smart contract
                          },
                          child: Text(
                            'SEND',
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
                            ///call the function to retreve from the smart contract
                          },
                          child: Text(
                            'Get Saved Text',
                            style: TextStyle(color: Colors.white),
                          )),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  /*  Row(
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
                  ),*/
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
