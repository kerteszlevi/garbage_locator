part of 'publish_bloc.dart';

@immutable
sealed class PublishState {}

final class PublishInitialState extends PublishState {}

class PublishPublishingState extends PublishState {}

class PublishPublishedState extends PublishState {
  final Garbage garbage;

  PublishPublishedState(this.garbage);
}

class PublishSavingImageState extends PublishState {}

class PublishGettingLocationState extends PublishState {}

class PublishGettingPlacemarkState extends PublishState {}
