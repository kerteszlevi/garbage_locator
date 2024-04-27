part of 'camera_bloc.dart';

@immutable
sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

//event for when the camera has started up
final class CameraScreenUp extends CameraEvent {}

//event for when the camera is requested
final class CameraRequest extends CameraEvent {}

//event for when a picture has been taken
final class PictureTaken extends CameraEvent {
  final String imagePath;

  const PictureTaken(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}
