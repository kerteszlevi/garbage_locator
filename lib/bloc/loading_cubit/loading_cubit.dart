import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingHidden());

  void showLoading(String loadingText) {
    emit(LoadingShown(loadingText: loadingText));
  }

  void updateLoadingText(String loadingText) {
    emit(LoadingShown(loadingText: loadingText));
  }

  void hideLoading() {
    emit(LoadingHidden());
  }
}
