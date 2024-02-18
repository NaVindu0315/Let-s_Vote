import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_vote/pages/Attempts/detailed_failed.dart';
import 'package:lets_vote/pages/Attempts/detailed_success_attempts.dart';
import 'package:lets_vote/pages/Attempts/detiled_other_Attempt.dart';

import '../../Colors/colors.dart';
import '../../firebase_options.dart';

late User loggedinuser;
late String client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(failed_Attempt_list());
}

class failed_Attempt_list extends StatefulWidget {
  @override
  fail_attempt createState() => fail_attempt();
}

class fail_attempt extends State<failed_Attempt_list> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('failed');

  String searchValue = ''; // Track the search value

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFDBD6E5),
        appBar: /* AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Other Failed Attempts',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFFDBD6E5),
        ),*/
            AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          title: Text(
            'Failed Attempt Details',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_image.jpg'),
              fit: BoxFit.cover, // Adjust fit as needed (cover, fill, etc.)
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  onChanged: (value) {
                    // Update the search value when the user types
                    setState(() {
                      searchValue = value;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width: 0.8),
                    ),
                    hintText: 'Search Here',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('failed')
                      .snapshots(),
                  //postsRef.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    // Filter the data based on the search value
                    final filteredData = snapshot.data!.docs.where((doc) {
                      final id = doc.id;

                      final search = searchValue.toLowerCase();
                      return id.contains(search);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final doc = filteredData[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return Card(
                          color: AppColors.backgroundcolor,
                          child: ListTile(
                            leading: Icon(
                              Icons.not_interested,
                              color: Colors.white,
                            ),
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Detailed_Fails(
                                          failedid: '${data['failedid']}')),
                                );
                                print('${data['failedid']}');
                              },
                              child: Ink(
                                child: Text(
                                  doc.id,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            trailing: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
