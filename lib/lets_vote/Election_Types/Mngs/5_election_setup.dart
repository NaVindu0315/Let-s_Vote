import 'package:firebase_database/firebase_database.dart';
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
  ///database referenneces
  late DatabaseReference _candidate1nameref;
  late DatabaseReference _candidate2nameref;
  late DatabaseReference _candidate3nameref;
  late DatabaseReference _candidate4nameref;
  late DatabaseReference _candidate5nameref;

  ///references end
  ///

  @override
  void initState() {
    super.initState();

    ///initialzing
    _candidate1nameref = FirebaseDatabase.instance.reference().child('candi_1');
    _candidate2nameref = FirebaseDatabase.instance.reference().child('candi_2');
    _candidate3nameref = FirebaseDatabase.instance.reference().child('candi_3');
    _candidate4nameref = FirebaseDatabase.instance.reference().child('candi_4');
    _candidate5nameref = FirebaseDatabase.instance.reference().child('candi_5');

    /// initialzing end
    /// assigning values
    /// 1 candidate
    _candidate1nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename1 = snapshot.value.toString();
        });
      }
    });

    ///2nd candidate
    _candidate2nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename2 = snapshot.value.toString();
        });
      }
    });

    ///3rd candidate
    _candidate3nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename3 = snapshot.value.toString();
        });
      }
    });

    ///4th candidate
    _candidate4nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename4 = snapshot.value.toString();
        });
      }
    });

    ///5th candidate
    _candidate5nameref.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          candidatename5 = snapshot.value.toString();
        });
      }
    });

    /// assgining values end
  }

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
