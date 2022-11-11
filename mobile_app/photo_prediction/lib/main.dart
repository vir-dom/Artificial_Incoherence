import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photo_prediction/predication_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PredicationScreen(),
  ));
}
