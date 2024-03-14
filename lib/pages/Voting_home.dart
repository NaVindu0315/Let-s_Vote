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
                          Column(
                              //to add buttons

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
