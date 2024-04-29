import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/screens/publish_screen.dart';
import '../bloc/camera/camera_bloc.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  static String route = '/';

  @override
  Widget build(BuildContext context) {
    //final cb = CameraBloc();
    return InitialView(/*cameraBloc: cb*/);
  }
}

class InitialView extends StatelessWidget {
  const InitialView({super.key /*, required this.cameraBloc*/});

  //final CameraBloc cameraBloc;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColor, //For Android
      statusBarColor: Theme.of(context).colorScheme.background, //For Android
      //TODO: define for every screen
      //statusBarIconBrightness: Brightness.dark, // For Android
      //statusBarBrightness: Brightness.light, // For iOS
    ));
    return BlocListener<CameraBloc, CameraState>(
      bloc: BlocProvider.of<CameraBloc>(context),
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

        body: Column(
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
                                  PopupMenuItem(
                                    value: 'camera',
                                    child: const Text('Open Camera'),
                                  ),
                                  PopupMenuItem(
                                    value: 'gallery',
                                    child: const Text('Select from Gallery'),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () {
                            //TODO: navigate to the my garbage collection screen

                            Navigator.pushNamed(context, '/collection_screen');
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
    );
  }
}
