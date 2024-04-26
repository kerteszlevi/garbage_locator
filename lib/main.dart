import 'package:flutter/material.dart';
import 'package:garbage_locator/screens/camera_screen.dart';
import 'package:garbage_locator/screens/initial_screen.dart';
import 'package:garbage_locator/screens/publish_screen.dart';
import 'package:garbage_locator/themes/myTheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garbage Locator',
      theme: myTheme,
      // theme:
      // ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      //home: const InitialScreen(),
      initialRoute: CameraScreen.route,
      routes: {
        InitialScreen.route: (context) => const InitialScreen(),
        CameraScreen.route: (context) => const CameraScreen(),
       // PublishScreen.route: (context) => const PublishScreen(imagePath: '',),
      },
    );
  }
}