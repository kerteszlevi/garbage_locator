part of 'publish_cubit.dart';

@immutable
sealed class PublishState {}

final class PublishInitialState extends PublishState {}

class PublishPublishingState extends PublishState {}

class PublishPublishedState extends PublishState {}

class PublishSavingImageState extends PublishState {}

class PublishGettingLocationState extends PublishState {}

class PublishGettingPlacemarkState extends PublishState {}

class PublishUploadingState extends PublishState {}

class PublishErrorState extends PublishState {
  final String error;

  PublishErrorState({required this.error}) : super();
}
