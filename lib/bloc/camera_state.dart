part of 'camera_bloc.dart';

@immutable
sealed class CameraState {}

final class CameraInitial extends CameraState {}

final class CameraError extends CameraState {
  final String message;

  CameraError(this.message);
}

final class PictureTakenState extends CameraState {
  final String imagePath;

  PictureTakenState(this.imagePath);
}


