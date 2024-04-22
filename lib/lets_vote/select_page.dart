import 'package:flutter/material.dart';
import 'package:lets_vote/pages/login.dart';

void main() {
  runApp(MaterialApp(
    home: Selection_page(),
  ));
}

class Selection_page extends StatefulWidget {
  @override
  State<Selection_page> createState() => _Selection_pageState();
}

class _Selection_pageState extends State<Selection_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade50,
        //AppBar
        appBar: AppBar(
          backgroundColor: Color(0xFF19589D),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
          title: const Text('Choose Your Role'),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 24),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //creating box 1
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => lgin()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFBFD8FF),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        color: Color(0xFFa9a9a9),
                      ),
                    ],
                  ),
                  height: 280.0,
                  width: 280.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/m.png',
                        height: 270.0,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 50.0),

              //creating box 2
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => lgin()));
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFBFD8FF),
                    borderRadius: BorderRadius.circular(30.0),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                        color: Color(0xFFa9a9a9),
                      ),
                    ],
                  ),
                  height: 280.0,
                  width: 280.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/e.png',
                        height: 270.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
