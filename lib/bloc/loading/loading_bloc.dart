import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingHidden()) {
    on<ShowLoading>((event, emit) {
      emit(LoadingShown(loadingText: event.loadingText));
    });

    on<UpdateLoadingText>((event, emit) {
      emit(LoadingShown(loadingText: event.loadingText));
    });
  }
}
