import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:lets_vote/pages/welcome%20screen.dart';

import '../Colors/colors.dart';

class Test_Enable_Disable extends StatefulWidget {
  const Test_Enable_Disable({Key? key}) : super(key: key);

  @override
  State<Test_Enable_Disable> createState() => _Test_Enable_DisableState();
}

class _Test_Enable_DisableState extends State<Test_Enable_Disable> {
  @override
  void initState() {
    super.initState();
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

              ///vote count display row
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Text('Enable')),
                  // Text('data'),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Text('Disable')),
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
                  ElevatedButton(onPressed: () {}, child: Text('Send')),
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
