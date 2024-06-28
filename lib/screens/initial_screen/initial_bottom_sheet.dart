import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  final Function()? onPressed;

  const MyBottomSheet({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.375, // 3/5 of the screen
        color: Theme.of(context).colorScheme.primary,
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: onPressed,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera, size: 30),
                    SizedBox(width: 10),
                    Text('Open Camera', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  foregroundColor: Colors.grey,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                onPressed: () {
                  // BlocProvider.of<CameraBloc>(context).add(GalleryRequested());
                  // Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.photo_library, size: 30),
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
  }
}
