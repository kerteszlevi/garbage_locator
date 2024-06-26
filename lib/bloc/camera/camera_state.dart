part of 'camera_cubit.dart';

@immutable
sealed class CameraState {}

final class CameraInitialState extends CameraState {}

final class CameraErrorState extends CameraState {
  final String message;

  CameraErrorState(this.message);
}

final class GalleryErrorState extends CameraState {
  final String message;

  GalleryErrorState(this.message);
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
