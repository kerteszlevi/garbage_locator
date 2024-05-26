import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/bloc/camera/camera_bloc.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/repository/firebase_garbage_repository.dart';
import 'package:garbage_locator/screens/camera_screen.dart';
import 'package:garbage_locator/screens/initial_screen.dart';
import 'package:garbage_locator/screens/collection_screen/my_collection_screen.dart';
import 'package:garbage_locator/screens/login_screen.dart';
import 'package:garbage_locator/screens/map_screen/map_screen.dart';
import 'package:garbage_locator/themes/myTheme.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'bloc/loading/loading_bloc.dart';

//design todos:
//TODO: splash screen
//TODO: icon
//other todos:
//TODO: localization
//TODO: move logic out of the bloc-s
//TODO: cache images

void main() async {
  final Logger logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    FirebaseInitializer(),
  );
}

class FirebaseInitializer extends StatefulWidget {
  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  late Future<FirebaseApp> _initialization;

  Future<FirebaseApp> initFirebase() async {
    final fireBaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //print email f current user
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser!.email);
    } else {
      print("No user logged in");
    }

    return fireBaseApp;
  }

  @override
  void initState() {
    super.initState();
    _initialization = initFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Failed to initialize Firebase. :(",
                  textDirection: TextDirection.ltr,
                ),
              );
            }

            if (snapshot.hasData) {
              return const MyApp();
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class HomeScreenRenderer extends StatelessWidget {
  static const route = '/';
  @override
  Widget build(BuildContext context) {
    return Conditional.single(
      context: context,
      conditionBuilder: (context) {
        return FirebaseAuth.instance.currentUser != null;
      },
      widgetBuilder: (context) => const InitialScreen(),
      fallbackBuilder: (context) => LoginPage(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final dataSource = DataSource(FirebaseGarbageRepository());
    dataSource.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>(
          create: (context) => CameraBloc(),
        ),
        BlocProvider<LoadingBloc>(
          create: (context) => LoadingBloc(),
        ),
      ],
      child: Provider<DataSource>(
        create: (_) => dataSource,
        child: MaterialApp(
          title: 'Garbage Collector',
          theme: myTheme,
          home: HomeScreenRenderer(),
          routes: {
            InitialScreen.route: (context) => const InitialScreen(),
            CameraScreen.route: (context) => const CameraScreen(),
            CollectionScreen.route: (context) => const CollectionScreen(),
            MapScreen.route: (context) => const MapScreen(),
            LoginPage.route: (context) => LoginPage(),
          },
        ),
      ),
    );
  }
}
