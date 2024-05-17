import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/screens/publish_screen.dart';
import '../bloc/camera/camera_bloc.dart';
import '../bloc/loading/loading_bloc.dart';
import 'loading_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  static String route = '/';

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState(){
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
    return const InitialView(/*cameraBloc: cb*/);
  }
}

class InitialView extends StatelessWidget {
  const InitialView({super.key /*, required this.cameraBloc*/});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor, //For Android
      //statusBarColor: Theme.of(context).colorScheme.background, //For Android
      statusBarColor: Colors.transparent,
      //systemNavigationBarColor: Colors.transparent,

      //TODO: define for every screen
      //statusBarIconBrightness: Brightness.dark, // For Android
      //statusBarBrightness: Brightness.light, // For iOS
    ));
    return MultiBlocListener(
      listeners: [
        BlocListener<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state is PictureTakenState) {
              //TODO: fix the push pop mess with the camera waiting screen
              //Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  //navigating to the publish screen and passing the image path of the taken photo
                  builder: (context) => PublishScreen(imagePath: state.imagePath),
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
                  builder: (context) => PublishScreen(imagePath: state.imagePath),
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
                  return LoadingScreen(loadingTextStream: BlocProvider.of<LoadingBloc>(context).loadingTextController.stream);
                },
              );
            } else if (state is LoadingHidden) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],

      child: Scaffold(
        //extendBody: true, //TODO: not working as intended, find a way to stretch the scaffold behind the navbar on android
        //bottomNavigationBar: const SizedBox(),
        //extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: Theme.of(context).colorScheme.background,
        //
        //     statusBarIconBrightness: Brightness.dark, // For Android
        //     statusBarBrightness: Brightness.light, // For iOS
        //   ),
        // ),

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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () async {
                                //TODO: popup menu is ugly find something usable an aesthetically pleasing
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
                              tag: 'myGarbageCollection',
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/collection_screen');
                                },
                                child: const Text('My garbage collection',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {
                                //navigate to the map screen
                                Navigator.pushNamed(context, '/map_screen');
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
            );
          } else {
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
                              tag: 'myGarbageCollection',
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/collection_screen');
                                },
                                child: const Text('My garbage collection',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                              ),
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
            );
          }
        }),
      ),
    );
  }
}
