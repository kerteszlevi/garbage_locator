import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/bloc/camera/camera_bloc.dart';
import 'package:garbage_locator/screens/camera_screen.dart';
import 'package:garbage_locator/screens/initial_screen.dart';
import 'package:garbage_locator/themes/myTheme.dart';

//design todos:
//TODO: splash screen
//TODO: icon
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      //TODO: decide where to define status bar and navigation bar color later on, for now it is defined here
      const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light, // For iOS
    statusBarIconBrightness: Brightness.dark, // For Android
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraBloc(),
      child: MaterialApp(
        title: 'Garbage Collector',
        theme: myTheme,
        //home: const InitialScreen(),
        initialRoute: InitialScreen.route,
        routes: {
          InitialScreen.route: (context) => const InitialScreen(),
          CameraScreen.route: (context) => const CameraScreen(),
        },
      ),
    );
  }
}
