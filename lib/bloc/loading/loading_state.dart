part of 'loading_bloc.dart';

@immutable
sealed class LoadingState {}

final class LoadingInitial extends LoadingState {}

class LoadingShown extends LoadingState {}

class LoadingHidden extends LoadingState {}
