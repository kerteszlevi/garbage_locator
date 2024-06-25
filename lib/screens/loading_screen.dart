import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/loading/loading_cubit.dart';

class LoadingScreen extends StatelessWidget {
  static const route = '/loading';

  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadingCubit, LoadingState>(
      builder: (context, state) {
        if (state is LoadingShown) {
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
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark, // For Android
                statusBarBrightness: Brightness.light, // For iOS
                systemNavigationBarColor: Colors.white,
              ),
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        state.loadingText,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
