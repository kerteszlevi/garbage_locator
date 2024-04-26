import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/screens/publish_screen.dart';
import 'package:garbage_locator/themes/myTheme.dart';

import '../bloc/camera_bloc.dart';
import 'camera_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  static String route = '/';

  @override
  Widget build(BuildContext context) {
    final cb = CameraBloc();
    return InitialView(cameraBloc: cb);
  }
}

class InitialView extends StatelessWidget {
  const InitialView({super.key, required this.cameraBloc});

  final CameraBloc cameraBloc;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor,
      statusBarColor: Theme.of(context).colorScheme.background,
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));
    return BlocListener<CameraBloc, CameraState>(
      bloc: cameraBloc,
      listener: (context, state) {
        if (state is PictureTakenState) {
          //TODO: fix the push pop mess with the camera waiting screen
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              //navigating to the publish screen and passing the image path of the taken photo
              builder: (context) => PublishScreen(imagePath: state.imagePath),
            ),
          );
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: Theme.of(context).colorScheme.background,
        //
        //     statusBarIconBrightness: Brightness.dark, // For Android
        //     statusBarBrightness: Brightness.light, // For iOS
        //   ),
        // ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/garbage.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Garbage Collector',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SafeArea(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              //TODO: navigate to the submit photo screen
                              //Navigator.pushNamed(context, '/publish');
                              //TODO: push pop mess also here.
                              Navigator.pushNamed(context, '/camera_screen');
                              cameraBloc.add(CameraStarted());
                            },
                            child: const Text('Submit Photo',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              //TODO: navigate to the my garbage collection screen
                            },
                            child: const Text('My garbage collection',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              //TODO: navigate to the map screen
                            },
                            child: const Text('Map',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
