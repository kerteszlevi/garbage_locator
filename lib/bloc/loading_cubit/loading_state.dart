part of 'loading_cubit.dart';

@immutable
sealed class LoadingState {}

class LoadingShown extends LoadingState {
  final String loadingText;
  LoadingShown({required this.loadingText}) : super();
}

class LoadingHidden extends LoadingState {}
