import 'package:flutter/material.dart';
import 'package:lets_vote/Colors/colors.dart';
import 'package:lets_vote/cam.dart';
import 'package:lets_vote/pages/comparing_page.dart';
import 'package:lets_vote/pages/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Voting_home.dart';

late User loggedinuser;
late String client;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController loggedinusercontroller = TextEditingController();
  TextEditingController imageurlcontroller = TextEditingController();

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
                    color: Color(0xDBD6E5FF), //color of list tiles
                    // Add a ListView to ensures the user can scroll
                    child: ListView(
                      // Remove if there are any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(0xFFFEB3DE), //color of drawer header
                          ),
                          accountName: Text(
                            '${data!['username']}',
                            style: TextStyle(
                                color: AppColors.backgroundcolor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
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
                            leading: Icon(Icons.home),
                            title: const Text('Home',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
                            onTap: () {
                              /*   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()),
                              );*/
                            },
                          );
                        }),
                        //Cam page
                        Builder(builder: (context) {
                          return ListTile(
                            leading: Icon(Icons.camera_alt),
                            title: const Text('Image Testing Page',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
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
                            leading: Icon(Icons.face),
                            title: const Text('Face Comparing Test',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
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
                            leading: Icon(Icons.how_to_vote),
                            title: const Text('Voting Home',
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 17)),
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
                  backgroundColor: Color(0xFFA888EB),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  title: Text('Welcome To Lets Vote'),

                  //centerTitle: true,
                ),
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 100, // Set the desired height
                        decoration: BoxDecoration(
                          color: Color(0xFFA888EB),
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
                                  color: Colors.indigo,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 170.0,
                            ),
                            Expanded(
                              child: CircleAvatar(
                                backgroundColor: Colors.purple,
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
                      ),
                      Text('${data!['url']}'),
                      Text(client),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => myapp()),
                            );
                          },
                          child: Text('Cam page')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Compare_page()),
                            );
                          },
                          child: Text('Validate page'))
                    ],
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    ));
  }
}
