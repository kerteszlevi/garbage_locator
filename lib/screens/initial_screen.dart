import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/screens/publish_screen.dart';
import '../bloc/camera/camera_bloc.dart';
import '../bloc/loading/loading_bloc.dart';
import '../utils.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

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
    return MultiBlocListener(
      listeners: [
        BlocListener<CameraBloc, CameraState>(
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
        BlocListener<LoadingBloc, LoadingState>(
          listener: (context, state) {
            if (state is LoadingShown) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingScreen(
                      loadingTextStream: BlocProvider.of<LoadingBloc>(context)
                          .loadingTextController
                          .stream);
                },
              );
            } else if (state is LoadingHidden) {
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
                      builder: (context) => LoginPage(),
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
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  onPressed: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (BuildContext context) {
                                        return ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(25.0)),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.375, // 3/5 of the screen
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Wrap(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0,
                                                          bottom: 8.0,
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                    ),
                                                    onPressed: () {
                                                      BlocProvider.of<
                                                                  CameraBloc>(
                                                              context)
                                                          .add(CameraRequest());
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(Icons.camera,
                                                            size: 30),
                                                        SizedBox(width: 10),
                                                        Text('Open Camera',
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      foregroundColor:
                                                          Colors.grey,
                                                    ),
                                                    onPressed: () {
                                                      // BlocProvider.of<CameraBloc>(context).add(GalleryRequested());
                                                      // Navigator.pop(context);
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                            Icons.photo_library,
                                                            size: 30),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          'Select from Gallery [WIP]',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Submit Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'myGarbageCollection',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/collection_screen');
                                  },
                                  child: const Text(
                                    'My garbage collection',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Hero(
                                tag: 'mapScreen',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  onPressed: () {
                                    //navigate to the map screen
                                    Navigator.pushNamed(context, '/map_screen');
                                  },
                                  child: const Text(
                                    'Map',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () async {
                                  //TODO: popup menu is ugly find something usable and aesthetically pleasing
                                  final selected = await showMenu(
                                      context: context,
                                      position: RelativeRect.fill,
                                      items: [
                                        const PopupMenuItem(
                                          value: 'camera',
                                          child: Text('Open Camera'),
                                        ),
                                        const PopupMenuItem(
                                          value: 'gallery',
                                          child: Text('Select from Gallery'),
                                        ),
                                      ]);
                                  if (selected == 'camera') {
                                    BlocProvider.of<CameraBloc>(context)
                                        .add(CameraRequest());
                                  } else if (selected == 'gallery') {
                                    BlocProvider.of<CameraBloc>(context)
                                        .add(GalleryRequested());
                                  }

                                  //TODO: push pop mess also here.
                                  //TODO: ui jitter fix when opening camera
                                  //BlocProvider.of<CameraBloc>(context).add(CameraRequest());
                                },
                                child: const Text('Submit Photo',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                              Hero(
                                flightShuttleBuilder: _flightShuttleBuilder,
                                tag: 'myGarbageCollection',
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(15),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/collection_screen');
                                  },
                                  child: const Text(
                                    'My garbage collection',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/map_screen');
                                },
                                child: const Text(
                                  'Map',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
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
