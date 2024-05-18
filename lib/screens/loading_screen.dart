import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Stream<String> loadingTextStream;

  const LoadingScreen({super.key, required this.loadingTextStream});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please wait...'),
            ),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              StreamBuilder<String>(
                stream: loadingTextStream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(fontSize: 20),
                    );
                  } else {
                    return const Text(
                      'Loading...',
                      style: TextStyle(fontSize: 20),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
