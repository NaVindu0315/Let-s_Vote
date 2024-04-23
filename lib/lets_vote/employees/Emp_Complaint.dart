import 'package:flutter/material.dart';

import '../../Colors/colors.dart';
import 'emp_dashboard.dart';

class Emp_Complaints extends StatefulWidget {
  const Emp_Complaints({Key? key}) : super(key: key);

  @override
  State<Emp_Complaints> createState() => _Emp_ComplaintsState();
}

class _Emp_ComplaintsState extends State<Emp_Complaints> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundcolor,
      ),
      home: Scaffold(
        appBar: AppBar(
          // preferredSize: Size.fromHeight(kToolbarHeight + 20),
          backgroundColor: AppColors.backgroundcolor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emp_Dashboard()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            'Report Your Issues',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
      ),
    );
  }
}
