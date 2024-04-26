import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial()) {
    on<CameraStarted>((event, emit) async{
      final ImagePicker _picker = ImagePicker();
      final XFile? file = await _picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        emit(PictureTakenState(file.path));
      } else {
        emit(CameraError('Error taking picture'));
      }
    });
    on<PictureTaken>((event, emit) {
      //TODO: navigate to the publish screen
      emit(PictureTakenState(event.imagePath));
    });
  }
}
