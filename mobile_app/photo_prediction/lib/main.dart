import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photo_prediction/predication_screen.dart';

Future<void> main() async {
  List<CameraDescription> cameras;
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PredicationScreen(),
  ));
}
