import 'package:flutter/material.dart';

class voting_home extends StatefulWidget {
  const voting_home({Key? key}) : super(key: key);

  @override
  State<voting_home> createState() => _voting_homeState();
}

class _voting_homeState extends State<voting_home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [Text('Lets vote now')],
        ),
      ),
    );
  }
}
