part of 'camera_bloc.dart';

@immutable
sealed class CameraState {}

//initial state
final class CameraInitialState extends CameraState {}

final class CameraErrorState extends CameraState {
  final String message;

  CameraErrorState(this.message);
}

//state for when a picture has already been taken and selected
final class PictureTakenState extends CameraState {
  final String imagePath;

  PictureTakenState(this.imagePath);
}

//state for when the camera is starting up and the user is waiting
final class CameraStartingState extends CameraState {}

final class PictureSelectedState extends CameraState {
  final String imagePath;

  PictureSelectedState(this.imagePath);
}
