import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:lets_vote/pages/welcome%20screen.dart';

import 'package:firebase_database/firebase_database.dart';

class testgraph extends StatefulWidget {
  const testgraph({Key? key}) : super(key: key);

  @override
  State<testgraph> createState() => _testgraphState();
}

class _testgraphState extends State<testgraph> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  final storage = FirebaseStorage.instance;

  late DatabaseReference _databaseReference;
  late DatabaseReference _databaseReference1;
  late DatabaseReference _databaseReference2;
  late DatabaseReference _databaseReference3;
  late DatabaseReference _databaseReference4;
  late DatabaseReference _databaseReference11;
  late DatabaseReference _databaseReference12;
  late DatabaseReference _databaseReference13;
  late DatabaseReference _databaseReference14;

  late String dt1;
  late String dt2;
  late String dt3;
  late String dt4;

  late double hp1;
  late double hp2;
  late double hp3;
  late double hp4;

  @override
  void initState() {
    super.initState();

    /// Initialize the FirebaseDatabase reference
    _databaseReference1 = FirebaseDatabase.instance.reference().child('hp1');
    _databaseReference1.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          hp1 = snapshot.value as double;
        });
      }
    });

    _databaseReference2 = FirebaseDatabase.instance.reference().child('hp2');
    _databaseReference2.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          hp2 = snapshot.value as double;
        });
      }
    });

    _databaseReference3 = FirebaseDatabase.instance.reference().child('hp3');
    _databaseReference3.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          hp3 = snapshot.value as double;
        });
      }
    });

    _databaseReference4 = FirebaseDatabase.instance.reference().child('hp4');
    _databaseReference4.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          hp4 = snapshot.value as double;
        });
      }
    });

    _databaseReference11 = FirebaseDatabase.instance.reference().child('dt1');
    _databaseReference11.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          dt1 = snapshot.value.toString();
        });
      }
    });
    _databaseReference11 = FirebaseDatabase.instance.reference().child('dt1');
    _databaseReference11.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          dt1 = snapshot.value.toString();
        });
      }
    });
    _databaseReference12 = FirebaseDatabase.instance.reference().child('dt2');
    _databaseReference12.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          dt2 = snapshot.value.toString();
        });
      }
    });
    _databaseReference13 = FirebaseDatabase.instance.reference().child('dt3');
    _databaseReference13.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          dt3 = snapshot.value.toString();
        });
      }
    });

    _databaseReference14 = FirebaseDatabase.instance.reference().child('dt4');
    _databaseReference14.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        setState(() {
          dt4 = snapshot.value.toString();
        });
      }
    });

    /// Initialize the camera controller
  }

  Widget chartToRun() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Example shows how to create ChartOptions instance
    //   which will request to start Y axis at data minimum.
    // Even though startYAxisAtDataMinRequested is set to true, this will not be granted on bar chart,
    //   as it does not make sense there.
    chartOptions = const ChartOptions(
      dataContainerOptions: DataContainerOptions(
        startYAxisAtDataMinRequested: true,
      ),
    );
    chartData = ChartData(
      dataRows: [
        //[20.0, 25.0, 30.0, 35.0, 40.0, 20.0],
        [hp1, hp2, hp3, hp4],
      ],
      xUserLabels: [dt1, dt2, dt3, dt4],
      dataRowsLegends: const [
        //'Off zero 1',
        'Off zero 2',
      ],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashBoard()),
                          );
                        },
                        child: Text('Home'))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 300, // specify a fixed height
                      width: 400, // specify a fixed width
                      child: chartToRun(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 50,
                  width: 350, // Set the width of the SizedBox to 300 pixels
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      //    controller: lvlcontroller,
                      onChanged: (value) {
                        //email = value;
                        //        setlvl = double.parse(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.settings,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Set New Value')),

                ///dt2
                SizedBox(
                  height: 50,
                  width: 350, // Set the width of the SizedBox to 300 pixels
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      //    controller: lvlcontroller,
                      onChanged: (value) {
                        //email = value;
                        //        setlvl = double.parse(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.settings,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Set New Value')),

                ///dt3
                SizedBox(
                  height: 50,
                  width: 350, // Set the width of the SizedBox to 300 pixels
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      //    controller: lvlcontroller,
                      onChanged: (value) {
                        //email = value;
                        //        setlvl = double.parse(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.settings,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Set New Value')),

                ///dt4
                SizedBox(
                  height: 50,
                  width: 350, // Set the width of the SizedBox to 300 pixels
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      //    controller: lvlcontroller,
                      onChanged: (value) {
                        //email = value;
                        //        setlvl = double.parse(value);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.settings,
                        ),
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('Set New Value')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
