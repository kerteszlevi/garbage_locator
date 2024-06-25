part of 'loading_bloc.dart';

@immutable
sealed class LoadingState {}

class LoadingShown extends LoadingState {
  final String loadingText;
  LoadingShown({required this.loadingText}) : super();
}

class LoadingHidden extends LoadingState {}
