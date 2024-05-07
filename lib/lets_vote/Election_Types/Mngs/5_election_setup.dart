import 'package:flutter/material.dart';

import '../../../Colors/colors.dart';
import '../../management/mng_election_select_page.dart';

class election_setup_5 extends StatefulWidget {
  const election_setup_5({Key? key}) : super(key: key);

  @override
  State<election_setup_5> createState() => _election_setup_5State();
}

class _election_setup_5State extends State<election_setup_5> {
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
                MaterialPageRoute(
                    builder: (context) => mng_election_type_select()),
              ); // go back to the previous screen
            },
          ),

          title: Text(
            '5 Person Election ',
            style: TextStyle(fontSize: 26.0, color: AppColors.buttoncolor),
          ),
          iconTheme: IconThemeData(color: Colors.white),

          //centerTitle: true,
        ),
      ),
    );
  }
}
