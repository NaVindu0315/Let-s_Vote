import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/cam.dart';
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

late User loggedinuser;
late String client;

class voting_home extends StatefulWidget {
  const voting_home({Key? key}) : super(key: key);

  @override
  State<voting_home> createState() => _voting_homeState();
}

class _voting_homeState extends State<voting_home> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  ///to get the current user
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      // final user = await _auth.currentUser();
      ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        client = loggedinuser.email!;

        ///i have to call the getdatafrm the function here and parse client as a parameter

        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  ///for blockchain
  ///
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
  final String contractAddress = '0xc691a5f193883bE1Ef4d03f0c7f60De8B88913A3';

  Future<void> getbalance() async {
    var ethClient = Web3Client(apiUrl, httpClient);
    var address = credentials.address;
    EtherAmount balance = await ethClient.getBalance(address);
    print(balance.getValueInUnit(EtherUnit.ether));
  }

  ///function begin

  ///to get json from firebase

  Future<String> getnamejson() async {
    final ref = FirebaseStorage.instance.ref('jsons/namecontract.json');
    final bytes = await ref.getData();
    final jsonString = utf8.decode(bytes!);
    return (jsonString);
  }

  Future<String> nameagejson() async {
    final ref = FirebaseStorage.instance.ref('jsons/agecontract.json');
    final bytes = await ref.getData();
    final jsonString = utf8.decode(bytes!);
    return (jsonString);
  }

  Future<String> getmyjson() async {
    final ref = FirebaseStorage.instance.ref('jsons/contract.json');
    final bytes = await ref.getData();
    final jsonString = utf8.decode(bytes!);
    return (jsonString);
  }

  ///end
  /// function
  /// new try

  //late Web3Client ethClient;

// Ethereum address
  final String myAddress = "0x3C3f0990BAcd02C0ed689bf4Dd6CE18cD3D6A0bF";

// URL from Infura
  final String blockchainUrl =
      "https://sepolia.infura.io/v3/4887f9655ec94842a2d3206deae69ad2";
/*
  Future<DeployedContract> getContract() async {
    String contractAddress = "0xc691a5f193883bE1Ef4d03f0c7f60De8B88913A3";
    // Obtain our smart contract using rootbundle to access our json file
    /* String abiFile = await rootBundle.loadString("assets/contract.json");

    final contract = DeployedContract(ContractAbi.fromJson(abiFile, "Voting"),
        EthereumAddress.fromHex(contractAddress));*/
    final abiFile = await getjson();
    final contract = DeployedContract(ContractAbi.fromJson(abiFile, 'Voting'),
        EthereumAddress.fromHex(contractAddress));
    print("payyya");
    return contract;

    return contract;
  }
*/
  ///functions to get contracts
  Future<DeployedContract> getnamecontract() async {
    String contractAddress = "0x3787D8F37054cf954c02eAF65C8b37FB97946de5";

    final abiFile = await getnamejson();
    final namecontract = DeployedContract(
        ContractAbi.fromJson(abiFile, 'Voting'),
        EthereumAddress.fromHex(contractAddress));
    print("payyya");
    return namecontract;
  }

  Future<DeployedContract> getagecontract() async {
    String contractAddress = "0xd34780b7c47de1Cb09E81D4e9dE74a78CC821291";

    final abiFile = await nameagejson();
    final agecontract = DeployedContract(
        ContractAbi.fromJson(abiFile, 'Voting'),
        EthereumAddress.fromHex(contractAddress));
    print("payyya");
    return agecontract;
  }

  Future<DeployedContract> getfirst() async {
    String contractAddress = "0xc691a5f193883bE1Ef4d03f0c7f60De8B88913A3";

    final abiFile = await getmyjson();
    final firstcontract = DeployedContract(
        ContractAbi.fromJson(abiFile, 'Voting'),
        EthereumAddress.fromHex(contractAddress));
    print("payyya");
    return firstcontract;
  }

  ///contract functions end

  ///for name

  late String newname;
  Future<List<dynamic>> callnameFunction(String name) async {
    final pakeclient = Web3Client(blockchainUrl, httpClient);
    final contract = await getnamecontract();
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

  late String values;
  Future<List<dynamic>> callagefunction(String name) async {
    final pakeclient = Web3Client(blockchainUrl, httpClient);
    final contract = await getagecontract();
    final function = contract.function(name);
    final result = await pakeclient
        .call(contract: contract, function: function, params: []);
    print(result);
    if (result.length == 1 && result[0] is String) {
      values = result[0] as String;
    } else {
      values = 'Result is not a string.';
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: '$values',
      autoCloseDuration: const Duration(seconds: 4),
      showConfirmBtn: false,
    );
    return result;
  }

  late String didu;
  Future<List<dynamic>> callfirstfunction(String name) async {
    final pakeclient = Web3Client(blockchainUrl, httpClient);
    final contract = await getfirst();
    final function = contract.function(name);
    final result = await pakeclient
        .call(contract: contract, function: function, params: []);
    print(result);
    if (result.length == 1 && result[0] is String) {
      didu = result[0] as String;
    } else {
      didu = 'Result is not a string.';
    }
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: '$didu',
      autoCloseDuration: const Duration(seconds: 4),
      showConfirmBtn: false,
    );
    return result;
  }

  ///name end
  ///
  /// name and age contract

  ///end

  Future<void> loadJsonFromFirebase() async {
    final ref = FirebaseStorage.instance.ref('c/contract.json');
    final bytes = await ref.getData();
    final jsonString = utf8.decode(bytes!);
    print(jsonString);
  }

  ///
  ///blockchain end

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(client)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return Scaffold(
                resizeToAvoidBottomInset: false,

                ///navigation bar eka iwrii
                ///drawer
                drawer: Drawer(
                  width: 300,
                  child: Container(
                    color: AppColors.backgroundcolor, //color of list tiles
                    // Add a ListView to ensures the user can scroll
                    child: ListView(
                      // Remove if there are any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color:
                                AppColors.buttoncolor, //color of drawer header
                          ),
                          accountName: Text(
                            '${data!['username']}',
                            style: TextStyle(
                              color: AppColors.backgroundcolor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          accountEmail: Text(
                            client,
                            style: TextStyle(
                                color: AppColors.backgroundcolor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          currentAccountPicture: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('${data!['url']}'),
                          ),
                        ),

                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            title: const Text('Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              /*   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );*/
                            },
                          );
                        }),

                        ///management dashboard
                        //Home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.manage_accounts,
                              color: Colors.white,
                            ),
                            title: const Text('Management dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Management_Dashboard()),
                              );
                            },
                          );
                        }),
                        //Cam page
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            title: const Text('Image Testing Page',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myapp()),
                              );
                            },
                          );
                        }),
                        //Announcement
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.face,
                              color: Colors.white,
                            ),
                            title: const Text('Face Comparing Test',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Compare_page()),
                              );
                            },
                          );
                        }),

                        ///voting home
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(
                              Icons.how_to_vote,
                              color: Colors.white,
                            ),
                            title: const Text('Voting Home',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => voting_home()),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                ///drawwe end
                appBar: AppBar(
                  // preferredSize: Size.fromHeight(kToolbarHeight + 20),
                  backgroundColor: AppColors.backgroundcolor,

                  title: Text(
                    'Voting Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),

                  //centerTitle: true,
                ),
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/bg_image.jpg'), // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SafeArea(
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

                          CircleAvatar(
                              backgroundColor: AppColors.backgroundcolor,
                              minRadius: 70.5,
                              child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      //AssetImage('images/g.png'),
                                      NetworkImage('${data!['url']}'))),

                          ///column
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Spacer(),
                              Row(
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        getbalance();

                                        callfirstfunction("get_output");
                                      },
                                      child: Text('First Function')),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        callnameFunction("getname");
                                      },
                                      child: Text('Name')),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        //  agefunction("getname");
                                        callagefunction("getname");
                                      },
                                      child: Text('Name ')),
                                  ElevatedButton(
                                      onPressed: () {
                                        //  agefunction("getdob");

                                        callagefunction("getdob");
                                      },
                                      child: Text(' Birthday')),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: 'working!',
                                          autoCloseDuration:
                                              const Duration(seconds: 4),
                                          showConfirmBtn: false,
                                        );
                                      },
                                      child: Text('alert test')),
                                  Spacer(),
                                ],
                              ),
                              Row(
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        loadJsonFromFirebase();
                                      },
                                      child: Text('Json Test')),
                                  Spacer(),
                                ],
                              ),
                              //   Spacer(),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    ));
  }
}
