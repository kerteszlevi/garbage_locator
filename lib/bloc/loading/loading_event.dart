part of 'loading_bloc.dart';

@immutable
sealed class LoadingEvent {}

class ShowLoading extends LoadingEvent {
  final String loadingText;

  ShowLoading(this.loadingText);
}

class UpdateLoadingText extends LoadingEvent {
  final String loadingText;

  UpdateLoadingText(this.loadingText);
}