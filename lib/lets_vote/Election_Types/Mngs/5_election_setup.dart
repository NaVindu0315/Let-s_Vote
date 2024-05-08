import 'package:flutter/material.dart';

import '../../../Colors/colors.dart';
import '../../management/mng_election_select_page.dart';

class election_setup_5 extends StatefulWidget {
  const election_setup_5({Key? key}) : super(key: key);

  @override
  State<election_setup_5> createState() => _election_setup_5State();
}

class _election_setup_5State extends State<election_setup_5> {
  ///declaring variables to fetch from rtdb
  String candidatename1 = "-";
  String candidatename2 = "-";
  String candidatename3 = "-";
  String candidatename4 = "-";
  String candidatename5 = "-";

  int cn1votes = 0;
  int cn2votes = 0;
  int cn3votes = 0;
  int cn4votes = 0;
  int cn5votes = 0;

  ///variables end
  ///variables to set
  String name1candi = "";
  String name2candi = "";
  String name3candi = "";
  String name4candi = "";
  String name5candi = "";

  ///variables to set end
  ///
  ///controllers
  TextEditingController name1controller = TextEditingController();
  TextEditingController name2controller = TextEditingController();
  TextEditingController name3controller = TextEditingController();
  TextEditingController name4controller = TextEditingController();
  TextEditingController name5controller = TextEditingController();

  ///controllers end

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundcolor,
      ),
      home: Scaffold(
        appBar: AppBar(
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
