import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitialState()) {
    //when the camera screen has been navigated to,
    //start the camera and request the user to take a picture
    on<CameraScreenUp>((event, emit) async {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        //when the picture is taken we navigate to the publish screen
        emit(PictureTakenState(file.path));
      } else {
        //TODO:this is not used rn. do i need an error state?
        emit(CameraErrorState('Error taking picture'));
      }
    });
    on<GalleryRequested>((event, emit) async {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        //when the picture is taken we navigate to the publish screen
        emit(PictureSelectedState(file.path));
      } else {
        emit(GalleryErrorState('Error selecting photo from gallery'));
      }
    });
    on<PictureTaken>((event, emit) {
      emit(PictureTakenState(event.imagePath));
    });
    on<CameraRequest>((event, emit) {
      emit(CameraStartingState());
    });
  }
}
