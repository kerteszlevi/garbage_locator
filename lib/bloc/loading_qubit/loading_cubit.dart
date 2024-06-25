import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  final StreamController<String> loadingTextController =
      StreamController<String>();

  LoadingCubit() : super(LoadingInitial());

  void showLoading() => (event, emit) {
        loadingTextController.add(event.loadingText);
        emit(LoadingShown());
      };
}
