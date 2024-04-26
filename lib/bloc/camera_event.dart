part of 'camera_bloc.dart';

@immutable
sealed class CameraEvent extends Equatable{
  const CameraEvent();

  @override
  List<Object> get props => [];
}

final class CameraStarted extends CameraEvent {}

final class PictureTaken extends CameraEvent{
  final String imagePath;

  const PictureTaken(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}