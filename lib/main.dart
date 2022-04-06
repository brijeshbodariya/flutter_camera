import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/constant/constant.dart';
import 'package:flutter_camera/screen/camera_home_screen.dart';
import 'package:flutter_camera/screen/home_screen.dart';
import 'package:flutter_camera/screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logs('Camera exception --> ${e.code} : ${e.description}');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Camera App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        homeScreen: (BuildContext context) => const HomeScreen(),
        cameraScreen: (BuildContext context) =>
            CameraHomeScreen(cameras: cameras),
      },
    );
  }
}
