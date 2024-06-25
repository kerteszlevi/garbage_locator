import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitialState());

  //when the camera screen has been navigated to,
  //start the camera and request the user to take a picture
  void cameraScreenUp() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      //when the picture is taken we navigate to the publish screen
      emit(PictureTakenState(file.path));
    } else {
      emit(CameraErrorState('Error taking picture'));
    }
  }

  void galleryRequested() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      //when the picture is taken we navigate to the publish screen
      emit(PictureSelectedState(file.path));
    } else {
      emit(GalleryErrorState('Error selecting photo from gallery'));
    }
  }

  void pictureTaken(String imagePath) {
    emit(PictureTakenState(imagePath));
  }

  void cameraRequest() {
    emit(CameraStartingState());
  }
}
