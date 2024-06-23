import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/bloc/publish/publish_bloc.dart';
import 'package:garbage_locator/main.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/screens/publish_screen/comment_box.dart';
import 'package:garbage_locator/screens/publish_screen/submit_button.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/screens/collection_screen/my_collection_screen.dart';
import 'package:provider/provider.dart';

import '../loading_screen.dart';

class PublishScreen extends StatelessWidget {
  final String imagePath;
  final _commentController = TextEditingController();
  final _loadingTextController = StreamController<String>();
  PublishScreen({super.key, required this.imagePath});

  static String route = '/publish';

  void publishGarbage(BuildContext context) {
    //TODO: bloc
    final garbage = Garbage(
      author: 'Unknown',
      imagePath: imagePath,
      comment: _commentController.text,
      location: 'Unknown',
      latitude: -1,
      longitude: -1,
    );
    context.read<PublishBloc>().add(PublishGarbage(garbage));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PublishBloc(Provider.of<DataSource>(context, listen: false)),
      child: BlocConsumer<PublishBloc, PublishState>(
        listener: (context, state) {
          if (state is PublishPublishedState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const HomeScreenRenderer()),
              (Route<dynamic> route) => false,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CollectionScreen(),
              ),
            );
            _loadingTextController.close();
          } else if (state is PublishPublishingState) {
            //push loading screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoadingScreen(
                  loadingTextStream: _loadingTextController.stream,
                ),
              ),
            );
            _loadingTextController.add('Publishing...');
          } else if (state is PublishSavingImageState) {
            _loadingTextController.add('Saving image...');
          } else if (state is PublishGettingLocationState) {
            _loadingTextController.add('Getting location data...');
          } else if (state is PublishGettingPlacemarkState) {
            _loadingTextController.add('Getting placemark data...');
          } else if (state is PublishUploadingState) {
            _loadingTextController.add('Uploading data...');
          }
        },
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light, // For Android
              statusBarBrightness: Brightness.light, // For iOS
              systemNavigationBarColor: Colors.transparent,
            ),
            child: Scaffold(
              body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    //open the image from the camera
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    //comment box
                    Center(
                        child: MyCommentBox(
                      commentController: _commentController,
                    )),
                    //submit button
                    SafeArea(
                      maintainBottomViewPadding: true,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: MySubmitButton(
                              onPressed: () {
                                publishGarbage(context);
                              },
                            )),
                      ),
                    ),
                    //close button
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 50,
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
        },
      ),
    );
  }
}
