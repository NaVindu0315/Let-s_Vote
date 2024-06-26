import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lets_vote/lets_vote/employees/emp_login.dart';
import 'package:lets_vote/lets_vote/select_page.dart';
import 'package:lets_vote/pages/login.dart';
import 'package:lets_vote/pages/signup.dart';
import 'cam.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //for the camera
  cameras = await availableCameras();
  //runApp(myapp());
  runApp(Emp_login());
}
