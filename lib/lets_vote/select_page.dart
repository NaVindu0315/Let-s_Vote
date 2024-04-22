import 'package:flutter/material.dart';

import '../pages/Voting_home.dart';

class Selection_page extends StatefulWidget {
  const Selection_page({Key? key}) : super(key: key);

  @override
  State<Selection_page> createState() => _Selection_pageState();
}

class _Selection_pageState extends State<Selection_page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => voting_home()),
                  );
                },
                child: Text("paka"))
          ],
        ),
      ),
    );
  }
}
