import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatelessWidget {
  static String route = '/camera';
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));
    return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.grey,
            size: 100,
          ),
        ));
  }
}
