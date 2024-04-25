import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(CameraInitial()) {
    on<CameraEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
