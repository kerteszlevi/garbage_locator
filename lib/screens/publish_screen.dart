import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garbage_locator/bloc/publish/publish_bloc.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:provider/provider.dart';

class PublishScreen extends StatelessWidget {
  final String imagePath;
  final _commentController = TextEditingController();
  PublishScreen({super.key, required this.imagePath});

  static String route = '/publish';


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ));
    return BlocProvider(
      create: (context) => PublishBloc(Provider.of<DataSource>(context, listen: false)),
  child: BlocConsumer<PublishBloc, PublishState>(
  listener: (context, state) {
    if(state is PublishPublishedState){
      Navigator.pop(context);
    }
  },
  builder: (context, state) {
    return Scaffold(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Add comment to your garbage',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Type in comment...',
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
              //submit button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        //TODO: bloc
                        final garbage = Garbage(
                          imagePath: imagePath,
                          comment: _commentController.text,
                          location: 'location_test',
                          latitude: 'latitude_test',
                          longitude: 'longitude_test',
                        );
                        context.read<PublishBloc>().add(PublishGarbage(garbage));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.all(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ),
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
          )),
    );
  },
),
);
  }
}
