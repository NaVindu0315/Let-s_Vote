import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:lets_vote/pages/welcome%20screen.dart';

import '../Colors/colors.dart';

late User loggedinuser;
late String client;

class Test_Enable_Disable extends StatefulWidget {
  const Test_Enable_Disable({Key? key}) : super(key: key);

  @override
  State<Test_Enable_Disable> createState() => _Test_Enable_DisableState();
}

class _Test_Enable_DisableState extends State<Test_Enable_Disable> {
  late DatabaseReference uidref;
  String uuiid = "";
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
        print(loggedinuser.uid);
        uuiid = loggedinuser.uid;
      }
    } catch (e) {
      print(e);
    }

    Future<String> uidreturn() async {
      try {
        // final user = await _auth.currentUser();
        ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          loggedinuser = user;
          client = loggedinuser.email!;

          ///i have to call the getdatafrm the function here and parse client as a parameter

          print(loggedinuser.email);
          print(loggedinuser.uid);
        }
      } catch (e) {
        print(e);
      }
      return loggedinuser.uid;
    }
  }

  Future<void> deactivatebutton() async {
    await uidref.set(0);
  }

  Future<void> activatebutton() async {
    await uidref.set(1);
  }

  @override
  void initState() {
    super.initState();
    getcurrentuser();

    uidref = FirebaseDatabase.instance.reference().child('uuids/$uuiid/stat');
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
            'Test Enable Disable',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Text('Vote')),
                  // Text('data'),
                  Spacer(),
                ],
              ),

              ///vote count display row
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        activatebutton();
                      },
                      child: Text('Enable')),
                  // Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        deactivatebutton();
                      },
                      child: Text('Disable')),
                  // Text('data'),
                  Spacer(),
                ],
              ),

              /// vote count display row end
              SizedBox(
                height: 10.0,
              ),

              ///row to display name of the candidates

              ///candidate display row end

              Spacer(),

              ///row for the buttons
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {}, child: Text('Activate Voting')),
                  // Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  // ElevatedButton(onPressed: () {}, child: Text('Send')),
                  Text('data'),
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
