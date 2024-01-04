import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class faceapi extends StatelessWidget {
  const faceapi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: facecompare(),
    );
  }
}

class facecompare extends StatefulWidget {
  const facecompare({Key? key}) : super(key: key);

  @override
  State<facecompare> createState() => _facecompareState();
}

class _facecompareState extends State<facecompare> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
