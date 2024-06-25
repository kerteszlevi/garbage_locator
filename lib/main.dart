import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/repository/firebase_garbage_repository.dart';
import 'package:garbage_locator/screens/camera_screen.dart';
import 'package:garbage_locator/screens/initial_screen/initial_screen.dart';
import 'package:garbage_locator/screens/collection_screen/my_collection_screen.dart';
import 'package:garbage_locator/screens/loading_screen.dart';
import 'package:garbage_locator/screens/login_screen.dart';
import 'package:garbage_locator/screens/map_screen/map_screen.dart';
import 'package:garbage_locator/themes/myTheme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import 'package:firebase_core/firebase_core.dart';
import 'bloc/camera/camera_cubit.dart';
import 'bloc/loading/loading_cubit.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// DISCLAIMER: the icons i'm using are not my own, i migrated and used a considerable amount of code from the github of the subject (github.com/bmeaut/VIAUAV45)
// ANOTHER DISCLAIMER: for some reason the app crashes after being relaunched on the emulator, i get weird opengl errors, but works fine on a real device i tested it both with an ios and android device.
// has not been tested on every api level nor ios version, i was  using api level 34 and ios 17 for testing
// landscape mode is not supported on the initial screen, everywhere else it works fine

// account with some pictures taken in emulator for testing: user: a@a.com pw: abcdefgh

// commands:
// build runner: flutter pub run build_runner build --delete-conflicting-outputs
// to generate icons: flutter pub run flutter_launcher_icons
//other todos:
//TODO: localization
//TODO: move logic out of the bloc-s didn't have time, sorry about that:((
//TODO: cache images
//TODO: finish extracting duplicated widgets

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const FirebaseInitializer(),
  );
}

class FirebaseInitializer extends StatefulWidget {
  const FirebaseInitializer({super.key});

  @override
  State<FirebaseInitializer> createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  late Future<FirebaseApp> _initialization;

  Future<FirebaseApp> initFirebase() async {
    final fireBaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //print email of current user
    if (FirebaseAuth.instance.currentUser != null) {
      print(FirebaseAuth.instance.currentUser?.email);
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
                  "Failed to initialize Firebase.",
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

  const HomeScreenRenderer({super.key});
  @override
  Widget build(BuildContext context) {
    return Conditional.single(
      context: context,
      conditionBuilder: (context) {
        return FirebaseAuth.instance.currentUser != null;
      },
      widgetBuilder: (context) => const InitialScreen(),
      fallbackBuilder: (context) => const LoginPage(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = DataSource(FirebaseGarbageRepository());
    dataSource.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraCubit>(
          create: (context) => CameraCubit(),
        ),
        BlocProvider<LoadingCubit>(
          create: (context) => LoadingCubit(),
        ),
      ],
      child: Provider<DataSource>(
        create: (_) => dataSource,
        child: MaterialApp(
          title: 'Garbage Collector',
          theme: myTheme,
          home: const HomeScreenRenderer(),
          routes: {
            InitialScreen.route: (context) => const InitialScreen(),
            CameraScreen.route: (context) => const CameraScreen(),
            CollectionScreen.route: (context) => const CollectionScreen(),
            MapScreen.route: (context) => const MapScreen(),
            LoginPage.route: (context) => const LoginPage(),
            LoadingScreen.route: (context) => const LoadingScreen(),
          },
        ),
      ),
    );
  }
}
