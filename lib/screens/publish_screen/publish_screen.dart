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

import '../../bloc/loading_cubit/loading_cubit.dart';

class PublishScreen extends StatelessWidget {
  final String imagePath;
  final _commentController = TextEditingController();

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
          } else if (state is PublishPublishingState) {
            context.read<LoadingCubit>().showLoading('Publishing...');
          } else if (state is PublishSavingImageState) {
            context.read<LoadingCubit>().updateLoadingText('Saving image...');
          } else if (state is PublishGettingLocationState) {
            context
                .read<LoadingCubit>()
                .updateLoadingText('Getting location...');
          } else if (state is PublishGettingPlacemarkState) {
            context
                .read<LoadingCubit>()
                .updateLoadingText('Getting placemark...');
          } else if (state is PublishUploadingState) {
            context.read<LoadingCubit>().updateLoadingText('Uploading...');
          } else if (state is PublishErrorState) {
            print('Error: ${state.error}');
            //show error dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.error),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //hide the loading screen
                        context.read<LoadingCubit>().hideLoading();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
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
