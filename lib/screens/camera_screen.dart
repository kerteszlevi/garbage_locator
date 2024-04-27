import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/bloc/camera/camera_bloc.dart';

class CameraScreen extends StatefulWidget {
  static String route = '/camera_screen';
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      BlocProvider.of<CameraBloc>(context).add(CameraScreenUp());
    });
  }

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
