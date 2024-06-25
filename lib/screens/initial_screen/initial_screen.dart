import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/screens/initial_screen/initial_button.dart';
import 'package:garbage_locator/screens/publish_screen/publish_screen.dart';
// ignore: unused_import
import '../../bloc/camera_cubit/camera_cubit.dart';
import '../../bloc/loading_cubit/loading_cubit.dart';
import 'initial_bottom_sheet.dart';
import '../../utils.dart';
import '../loading_screen.dart';
import '../login_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  static String route = '/initial';

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
  }

  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first == ConnectivityResult.none) {
      // No internet connection
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text(
            'No active network interface',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text(
                'Dismiss',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const InitialView();
  }
}

Widget _flightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoadingScreenShown = false;

    return MultiBlocListener(
      listeners: [
        BlocListener<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state is PictureTakenState) {
              //TODO: fix the push pop mess with the camera waiting screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  //navigating to the publish screen and passing the image path of the taken photo
                  builder: (context) =>
                      PublishScreen(imagePath: state.imagePath),
                ),
              );
            } else if (state is CameraStartingState) {
              Navigator.pushNamed(context, '/camera_screen');
            } else if (state is CameraErrorState) {
              Navigator.pop(context);
            } else if (state is PictureSelectedState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //navigating to the publish screen and passing the image path of the taken photo
                  builder: (context) =>
                      PublishScreen(imagePath: state.imagePath),
                ),
              );
            } else if (state is GalleryErrorState) {
              //TODO: remove this  later
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        BlocListener<LoadingCubit, LoadingState>(
          listener: (context, state) {
            if (state is LoadingShown && !isLoadingScreenShown) {
              isLoadingScreenShown = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingScreen();
                },
              );
            } else if (state is LoadingHidden && isLoadingScreenShown) {
              isLoadingScreenShown = false;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android
          statusBarBrightness: Brightness.light, // For iOS
          systemNavigationBarColor: Theme.of(context).primaryColor,
        ),
        child: Scaffold(
          //extendBody: true, //TODO: not working as intended, find a way to stretch the scaffold behind the navbar on android

          appBar: AppBar(
            leading: PopupMenuButton<String>(
              icon: const Icon(Icons.logout, color: Colors.black),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'SignOut',
                  child: Text('Sign Out', style: TextStyle(color: Colors.red)),
                ),
                const PopupMenuItem<String>(
                  value: 'Cancel',
                  child: Text('Cancel', style: TextStyle(color: Colors.black)),
                ),
              ],
              onSelected: (String action) {
                if (action == 'SignOut') {
                  logOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              },
            ),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                children: [
                  //TODO: animate trash falling and popping, and flies looping
                  Expanded(
                    //upper part, logo and title
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
                    //lower part, buttons
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SafeArea(
                        bottom: true,
                        top: false,
                        left: false,
                        right: false,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //TODO: make buttons scale dynamically
                              Hero(
                                tag: 'submitPhoto',
                                child: MyInitialButton(
                                  text: 'Submit Photo',
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return MyBottomSheet(
                                          onPressed: () {
                                            BlocProvider.of<CameraCubit>(
                                                    context)
                                                .cameraRequest();
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Hero(
                                tag: 'myGarbageCollection',
                                child: MyInitialButton(
                                  text: 'My garbage collection',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/collection_screen');
                                  },
                                ),
                              ),
                              Hero(
                                tag: 'mapScreen',
                                child: MyInitialButton(
                                  text: 'Map',
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/map_screen');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              //landscape orientation TODO: ditch the popup menu TODO: very sketchy implementation, might disable landscape later REMOVE LANDSCAPE ITS NOT FINISHED
              return Row(
                children: [
                  Expanded(
                    //upper part, logo and title
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
                    //lower part, buttons
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SafeArea(
                        bottom: true,
                        top: false,
                        left: false,
                        right: false,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //TODO: make buttons scale dynamically
                              //submit button
                              Hero(
                                tag: 'submitPhoto',
                                child: MyInitialButton(
                                  text: 'Submit Photo',
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return MyBottomSheet(
                                          onPressed: () {
                                            BlocProvider.of<CameraCubit>(
                                                    context)
                                                .cameraRequest();
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              //collection button
                              Hero(
                                tag: 'myGarbageCollection',
                                child: MyInitialButton(
                                  text: 'My garbage collection',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/collection_screen');
                                  },
                                ),
                              ),
                              Hero(
                                tag: 'mapScreen',
                                child: MyInitialButton(
                                  text: 'Map',
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/map_screen');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
