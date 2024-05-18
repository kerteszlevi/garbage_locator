import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  final StreamController<String> loadingTextController =
      StreamController<String>();

  LoadingBloc() : super(LoadingInitial()) {
    on<ShowLoading>((event, emit) {
      loadingTextController.add(event.loadingText);
      emit(LoadingShown());
    });

    on<UpdateLoadingText>((event, emit) {
      loadingTextController.add(event.loadingText);
    });
  }
}
