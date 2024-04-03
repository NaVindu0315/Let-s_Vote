import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/TestContract.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';
import 'package:lets_vote/pages/management_dashboard.dart';

import '../Colors/colors.dart';

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'; //You can also import the browser version
import 'package:web3dart/web3dart.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:io';

import 'Voting_home.dart';

class TestContract extends StatefulWidget {
  const TestContract({Key? key}) : super(key: key);

  @override
  State<TestContract> createState() => _TestContractState();
}

class _TestContractState extends State<TestContract> {
  TextEditingController txtcontroller = new TextEditingController();
  String txt = "";

  ///
  var apiUrl =
      "https://sepolia.infura.io/v3/4887f9655ec94842a2d3206deae69ad2"; //Replace with your API

  var httpClient = Client();

  var credentials = EthPrivateKey.fromHex(
      "bdb3d39f69282abbce39e6d834b762a6ab093d97b94411f018b1fe607ea017e6");

  ///to get
  // Replace with placeholders (refer to security note above)
  final String infuraEndpoint =
      'https://sepolia.infura.io/v3/4887f9655ec94842a2d3206deae69ad2'; // Replace with actual endpoint
  final String infuraApiKey =
      '4887f9655ec94842a2d3206deae69ad2'; // Replace with actual API key
  final String contractAddress = '0xe22b2b358a3ca9b3ead5d0ce79cc6e2214af9d15';

  final String myAddress = "0x3C3f0990BAcd02C0ed689bf4Dd6CE18cD3D6A0bF";

// URL from Infura
  final String blockchainUrl =
      "https://sepolia.infura.io/v3/4887f9655ec94842a2d3206deae69ad2";

  Future<void> getbalance() async {
    var ethClient = Web3Client(apiUrl, httpClient);
    var address = credentials.address;
    EtherAmount balance = await ethClient.getBalance(address);
    print(balance.getValueInUnit(EtherUnit.ether));
  }

  Future<String> getjson() async {
    final ref = FirebaseStorage.instance.ref('jsons/Test.json');
    final bytes = await ref.getData();
    final jsonString = utf8.decode(bytes!);
    return (jsonString);
  }

  Future<DeployedContract> gettestcontract() async {
    String contractAddress = "0xe22b2b358a3ca9b3ead5d0ce79cc6e2214af9d15";

    final abiFile = await getjson();
    final agecontract = DeployedContract(
        ContractAbi.fromJson(abiFile, 'Voting'),
        EthereumAddress.fromHex(contractAddress));
    print("payyya");
    return agecontract;
  }

  late String newname;
  Future<List<dynamic>> calltestfunction(String name) async {
    final pakeclient = Web3Client(blockchainUrl, httpClient);
    final contract = await gettestcontract();
    final function = contract.function(name);
    final result = await pakeclient
        .call(contract: contract, function: function, params: []);
    print(result);
    if (result.length == 1 && result[0] is String) {
      newname = result[0] as String;
    } else {
      newname = 'Result is not a string.';
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: '$newname',
      autoCloseDuration: const Duration(seconds: 4),
      showConfirmBtn: false,
    );
    return result;
  }

  ///
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
                            calltestfunction("tst");
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
                            print(txt);
                            txtcontroller.clear();
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
                            getbalance();

                            ///call the function to retreve from the smart contract
                            calltestfunction("viewtext");
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
