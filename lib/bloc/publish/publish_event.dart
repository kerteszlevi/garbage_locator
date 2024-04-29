part of 'publish_bloc.dart';

@immutable
sealed class PublishEvent {}

class PublishGarbage extends PublishEvent {
  final Garbage garbage;

  PublishGarbage(this.garbage);
}
