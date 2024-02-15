import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late User loggedinuser;
late String client;

class Detailed_other_error extends StatefulWidget {
  final String unknownid;

  Detailed_other_error({required this.unknownid});

  @override
  _Detailed_other_errorState createState() => _Detailed_other_errorState();
}

class _Detailed_other_errorState extends State<Detailed_other_error> {
  GlobalKey globalKey = new GlobalKey();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String selectedattempt;

  @override
  void initState() {
    super.initState();
    selectedattempt = widget.unknownid;
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('unknown Errors')
          .doc(selectedattempt)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;

          return

              ///material app begin
              MaterialApp(
            // Application name
            title: 'My Flutter App',
            debugShowCheckedModeBanner: false, // Remove debug banner
            home:

                ///should be cut out from here
                Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                toolbarHeight: 70,
                centerTitle: true,
                backgroundColor: const Color(0xFFACAFF2),
                // The title text which will be shown on the action bar
                title: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Attempt Detials',
                        style: TextStyle(
                          fontSize: 31,
                          color: Colors.indigo,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          ///Gem picture
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 200,
                              width: double.infinity,
                              color: Color(0xDBD6EFFF),
                              child: Image(
                                image: NetworkImage('${data!['profilepic']}'),
                              ),
                            ),
                          ),

                          ///gem pic end
                          ///qr
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 20),
                              height: 200,
                              width: double.infinity,
                              color: Color(0xDBD6EFFF),
                              child: Image(
                                image:
                                    NetworkImage('${data!['capturedimage']}'),
                              ),
                            ),
                          ),

                          ///qr end
                        ],
                      ),

                      ///gem code
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 60,
                        width: double.infinity,
                        color: Color(0xD1D3FCFF),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Email :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  height: 2,
                                ),
                              ),
                            ),

                            ///place the gemcode variable here
                            Expanded(
                              child: Text(
                                '${data?['email']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                  height: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///gem code end
                      ///gem name
                      ///gem name
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        height: 60,
                        width: double.infinity,
                        color: Color(0xD1D3FCFF),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                'Date & Time :',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  height: 2,
                                ),
                              ),
                            ),

                            ///place the gem name variable here
                            Expanded(
                              child: Text(
                                '${data?['date & time']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22,
                                  height: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///gem name end
                      ///gem name end
                      ///gem variety

                      ///total cost end
                      /* Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF43468E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              textStyle: TextStyle(
                                  fontSize: 20.0, color: Color(0xFF43468E)),
                            ),
                            child: Text('Back'),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              /*
                              FirebaseFirestore.instance
                                  .collection(client)
                                  .doc(selectedattempt)
                                  .delete();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => gemlist()),
                              );*/
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF43468E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              textStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            child: Text('sold'),
                          ),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          );

          /// materialapp end
        }
        return CircularProgressIndicator();
      },
    );
  }
}
